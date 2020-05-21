param(
    $dest = $(throw 'Usage: sshw <dest>'),
    $size = ""
)

if ( $size -ne '/f')
{
    mstsc /v:$dest /w:1360 /h:700
}
else
{
    mstsc /v:$dest /f
}