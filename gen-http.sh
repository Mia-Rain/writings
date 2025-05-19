#!/bin/sh
header='<head>
<link rel="icon" href="/favicon.png">
<link rel="stylesheet" href="/style.css">
<title>Writings</title>
</head>
<body class="vsc-initialized"><font color="#fffff">
<pre style="background-color: black">
    |
    |
----+-----------------------------------------------------
    | ---
    | w.transcendent.ink
    | -- some stuff weve written...
    | ---
    | Scripts'
footer='
    | ---
    |
    |
    |
</pre>
</font>
</body>
'
echo "$header"
for i in ./*; do
  printf '    | -- <a href="%s">%s</a>\n' ".${i#.}" "$i"
done
echo "$footer"
