declare default element namespace "http://www.w3.org/2005/Atom";
declare namespace app = "http://www.w3.org/2007/app";

let $collection := collection('dbxml:collections')/app:collection[@href=$path]
return
<feed>
<title type="text">{$collection/title/text()}</title>

<link href="{$path}" rel="self"/>

{
for $entry in collection('dbxml:entries')/entry
let $self_link := $entry/link[@rel="self"]
where tokenize($self_link/@href, '/')[2] = tokenize($path, '/')[2]
return $entry
}

</feed>
