class Xml

  # share manager and container config across all db subclasses
  cattr_accessor :manager, :container_config
  
  # individual container name per subclass
  class_inheritable_accessor :container_name

  # document per instance
  attr_accessor :document

  module Java
    include_class com.sleepycat.db.EnvironmentConfig
    include_class com.sleepycat.db.Environment
    include_class com.sleepycat.dbxml.XmlManagerConfig
    include_class com.sleepycat.dbxml.XmlManager
    include_class com.sleepycat.dbxml.XmlContainerConfig
    include_class com.sleepycat.dbxml.XmlDocumentConfig
    include_class com.sleepycat.dbxml.XmlException
    include_class com.sleepycat.dbxml.XmlValue
    include_class java.io.File
  end

  # set up environment
  ENV_DIR = Java::File.new(File.join(File.dirname(__FILE__), 'db', AppServer.environment))
  env_config = Java::EnvironmentConfig.new
  env_config.set_allow_create true
  env_config.set_initialize_cache true
  env_config.set_initialize_locking true
  env_config.set_initialize_logging true
  env_config.set_transactional true
  env_config.set_run_recovery true
  environment = Java::Environment.new(ENV_DIR, env_config)

  # set up manager
  manager_config = Java::XmlManagerConfig.new
  manager_config.set_allow_external_access(true)
  manager_config.set_adopt_environment(true)
  self.manager = Java::XmlManager.new(environment, manager_config)

  # set up container config
  self.container_config = Java::XmlContainerConfig.new
  self.container_config.set_allow_validation true
  self.container_config.set_node_container true
  self.container_config.set_index_nodes true 
  self.container_config.set_transactional true 
  self.container_config.set_allow_create true

  # wrap a dbxml transaction in a block
  # optionally grab the default container for the class
  def self.transaction(use_container = false, &block)
    txn = manager.create_transaction

    if use_container
      container = 
        manager.open_container txn, container_name, container_config
      yield txn, container
    else
      yield txn
    end

    txn.commit

  rescue
    txn.abort
    raise
  end

  # sugar
  def self.container_transaction(&block)
    transaction(true, &block)
  end

  def self.open_container(name = nil)
    name ||= container_name
    container = nil

    transaction do |txn|
      container = manager.open_container(txn, name, container_config)
    end

    container 
  end

  def self.query(query_content, args = {})
    context = manager.create_query_context

    context.set_base_uri("file://#{Merb.root}/")

    variables = args[:variables]
    output = ''

    if query_content.respond_to? :read
      query_content = query_content.read
    end

    if variables
      variables.each do |key, value|
        value = '' if value.nil?
        xml_value = Java::XmlValue.new value
        context.set_variable_value key.to_s, xml_value
      end
    end

    container_transaction do |txn, container|
      expression = manager.prepare txn, query_content, context

      if Merb.environment == 'development'
        Merb.logger.info("\n\n------------------ Query plan -----------------\n")
        Merb.logger.info(expression.get_query_plan)
      end

      results = expression.execute context
      while value = results.next do 
        output += value.as_string
      end
    end

    output
  end

  def self.create(options)
    object = new
    object.document = manager.create_document
    object.document.set_content(options[:content])

    container_transaction do |txn, container|
      context = manager.create_update_context
      object.document.set_name(options[:name])
      container.put_document(txn, object.document, context)
    end

    object
  end

  def self.find(name)
    object = new
    object.document = nil

    container_transaction do |txn, container|
      object.document = container.get_document(txn, name)
    end

    object
  end

  # as above, returning nil in place of raising
  def self.find_by_name(name)
    find(name)
  rescue Java::XmlException
    nil
  end

  def self.destroy(object)
    status = nil

    container_transaction do |txn, container|
      context = manager.create_update_context
      begin
        container.delete_document(txn, object, context)
        status = true
      rescue Java::XmlException
      end
    end
    return status
  end

end
