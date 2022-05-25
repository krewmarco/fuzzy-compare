. ./Get-ld.ps1

Enum CompareTypes {
	normal = 1
	levenstein = 2
}



class Comparison {
	[int] compare([string]$strA, $strB) {
		return [string]::Compare($strA, $strB)
	}
}

class StringComparison : Comparison {
	[boolean]$ignoreCase = $true
	[int] compare([string]$strA, $strB) {
		return [string]::Compare($strA, $strB, $this.ignoreCase)
	}
}

class LevensteinComparison : Comparison {
	$threshold = 2;
	[int] compare([string]$strA, $strB) {
		$dist = ./Get-ld $strA $strB
		$result = $dist -le $this.threshold
		return $result -eq $true ? 0 : 1;
	}
}

class ComparableString : System.IComparable {
	static $comparisons = @{
		levenstein = New-Object LevensteinComparison
		normal = New-Object StringComparison
	}

	hidden static $currentComparison = [ComparableString]::comparisons['normal']

	[string] $value

	ComparableString([string]$value) {
		$this.value = $value;
	}

	setComparisonType([string]$compare) {
		[ComparableString]::currentComparison = [ComparableString]::comparisons[$compare]
	}

	[int]CompareTo($that) {
		return [ComparableString]::currentComparison.compare($this.value, $that.value)
	}


	[string]ToString() {
		return $this.value;
	}
}