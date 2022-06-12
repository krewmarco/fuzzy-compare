. ./ComparableString.ps1


function Get-Column-Spec($template = '$expr') {
	process {
		if (($_ -match "(?<field>[a-z]+)(?: as (?<alias>[a-z]+))?$") -eq $false) {
			throw "Invalid columnspec: ${_}"
		}
		$field = $matches.field
		$alias = $matches.contains('alias') ? $matches.alias : $field
		$exprString ="`$_.$field" 
		$code = $template.replace('$expr',$exprString)
		@{n = $alias; e = [scriptblock]::create($code) }
	}
}

function Import-Csv-Column-Spec([string]$path, [string[]] $columnSpec) {
	Import-Csv -Path $path | Select-Object -Property ($columnSpec | Get-Column-Spec -template '[ComparableString]::new($expr)' )
}


class CompareData {
	[array]$left;
	[array]$right;
	[array]$same;


	CompareData([string]$csv1, [string]$csv2, [string[]]$columnSpec) {
		# choose the "left" elements
		$this.left = Import-Csv-Column-Spec -path $csv1 $columnSpec
		$this.right = Import-Csv-Column-Spec -path $csv2 $columnSpec
	}

	Compare([CompareTypes]$method = [CompareTypes]::equality) {
		
	}

}

function Compare-Rows([string]$csv1, [string]$csv2, [string[]]$columnSpec, [CompareTypes]$method = [CompareTypes]::inherit) {
	$data = [CompareData]::new($csv1, $csv2, $columnSpec)
	[ComparableString]::MyCompare = $method
	$results = Compare-Object -IncludeEqual -ReferenceObject $data.left -DifferenceObject $data.right -Property $columns 
	$results
}