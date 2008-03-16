declare default element namespace "http://www.w3.org/2005/Atom";
declare namespace app = "http://www.w3.org/2007/app";

let $collection := collection('dbxml:collections')/app:collection[@href=$path]
let $entries := 
  for $entry in collection('dbxml:entries')/entry
  let $self_link := $entry/link[@rel="self"]
  where tokenize($self_link/@href, '/')[2] = tokenize($path, '/')[2]
  return $entry

return
<feed>
<id>http://{$hostname}/</id>
<title type="text">{$collection/title/text()}</title>
{$entries[1]/updated}

<link href="http://{$hostname}{$path}" rel="self"/>

{$entries}

</feed>
