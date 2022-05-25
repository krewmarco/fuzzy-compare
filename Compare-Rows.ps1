. ./ComparableString.ps1

function Compare-Rows([string]$csv1, [string]$csv2, [string[]]$columns, [CompareTypes]$method=[CompareTypes]::inherit) {
	$left = Import-Csv -Path $csv1 | Select @{n = $columns[0]; e = { [ComparableString]::new($_.($columns[0])) } }
	$right = Import-Csv -Path $csv2 | Select @{n = $columns[1]; e = { [ComparableString]::new($_.($columns[1])) } }

	[ComparableString]::MyCompare = $method
	$results = Compare-Object -IncludeEqual -ReferenceObject $left -DifferenceObject $right -Property Name
	$results
}