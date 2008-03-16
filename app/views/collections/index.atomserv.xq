declare default element namespace "http://www.w3.org/2007/app";
declare namespace atom = "http://www.w3.org/2005/Atom";
<service>
  <workspace>
    <atom:title>My lovely AtomPub site</atom:title>
    {for $collection in collection('dbxml:collections') return $collection}
  </workspace>
</service>
