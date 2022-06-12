BeforeAll { 
	. $PSCommandPath.Replace(".Tests.ps1", ".ps1")
}


Describe 'Compare-Strings' {
	It 'Can compare strings' {
		Compare-Rows -Csv1 ./data/outlook/folders.csv -Csv2 ./data/outlook/uniqueRules.csv -columnspec Name
		# $results.Count | Should -Be 5
	}
}