declare default element namespace "http://www.w3.org/2005/Atom";
declare namespace atom = "http://www.w3.org/2005/Atom";
declare namespace app = "http://www.w3.org/2007/app";

let $collection := collection('dbxml:collections')/app:collection[@href=$path]
let $collection_identifier := tokenize($path, '/')[2]

let $entries := 
  for $entry in collection('dbxml:entries')/entry
  let $self_link := $entry/link[@rel="self"]
  let $entry_collection_identifier := tokenize($self_link/@href, '/')[2]

  where $entry_collection_identifier = $collection_identifier
  return $entry

return
<feed>
<id>http://{$hostname}/</id>
<title type="text">{$collection/title/text()}</title>
<author><name>Andrew Bruce</name></author>

{
if ($entries[1]) then $entries[1]/updated
else <updated>{current-dateTime()}</updated>
}

<link href="http://{$hostname}{$path}" rel="self"/>

{$entries}

</feed>
