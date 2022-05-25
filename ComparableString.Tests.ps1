BeforeAll { 
	. $PSCommandPath.Replace(".Tests.ps1", ".ps1")
}

Describe 'Comparable-Strings' {
	It 'Comparing <strA> with <strB> using method <method> results in <result>' -ForEach @(
		@{ strA="normal"; strB="abnormal";method=$null; result=1}
		@{ strA="normal"; strB="normal";method=$null; result=0}
		@{ strA="normal"; strB="Normal";method=$null; result=0}
		@{ strA="normal"; strB="formal";method='levenstein'; result=0}
		@{ strA="normal"; strB="normalized";method='levenstein'; result=1}
	) {
		$a = New-Object ComparableString($strA)
		$b = New-Object ComparableString($strB)
		if ($method -ne $null) {
			$a.setComparisonType($method)
		}
		$a.CompareTo($b) | Should -be $result
	}	
}