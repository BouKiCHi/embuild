# 
Param([bool]$verbose=$false)

Write-Host "Assembling..."

# git clone https://github.com/mucom88/mucom88 mucom88em

$srcDir = "mucom88em\mucom88em\src"

$a = @(
"errmsg","expand","kbd","msub",
"muc88","music","pcmldr","smon",
"ssgdat","time"
)

function assemble($src,$bin,$lst) {
    # Write-Output "assemble $src $bin $lst"
    if (Test-Path .\pasmo.exe) {
        .\pasmo $src $bin $lst
    } else {
        pasmo $src $bin $lst
    }
}

function bin2data($bin, $verbose) {
    $output =  .\bin2array $bin -p "bin_" -s "_em"
    if ($verbose) {
        $output
    }
}

$binDir = "bin"
$lstDir = "lst"
if (-Not (Test-Path $binDir)) { mkdir bin }
if (-Not (Test-Path $lstDir)) { mkdir lst }


foreach($v in $a) {
    $src = Join-Path $srcDir "${v}.asm"
    $bin = Join-Path $binDir $v
    $lst = Join-Path $lstDir "${v}.lst"
    assemble $src $bin $lst
    bin2data $bin $verbose
}

Write-Host "done."

$expandLst = Join-Path $lstDir "expand.lst"
$Data = Get-Content $expandLst

Write-Host "Patch Address"
$Data | Select-String "CULC"
$Data | Select-String "CULLP2"
$Data | Select-String "FRQBEF"
