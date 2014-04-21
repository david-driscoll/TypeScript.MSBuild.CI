if (Test-Path 'C:\Program Files (x86)\Microsoft SDKs\TypeScript\1.0') {
	Copy-Item 'C:\Program Files (x86)\Microsoft SDKs\TypeScript\1.0' '.\Microsoft SDKs\TypeScript\1.0' -Recurse	-Force 
}

if (Test-Path 'C:\Program Files (x86)\MSBuild\Microsoft\VisualStudio\v12.0\TypeScript') {
	Copy-Item 'C:\Program Files (x86)\MSBuild\Microsoft\VisualStudio\v12.0\TypeScript' '.\Microsoft\VisualStudio\TypeScript' -Recurse -Force 
}

[xml]$xml = Get-Content '.\Microsoft\VisualStudio\TypeScript\Microsoft.TypeScript.targets'

foreach ($task in $xml.Project.UsingTask) {
	if ($task.TaskName -eq 'TypeScript.Tasks.VsTsc') {
		$task.AssemblyFile = '$(MSBuildThisFileDirectory)\TypeScript.tasks.dll'
	}
}

foreach ($prop in $xml.Project.PropertyGroup) {
	#$prop.GetType().GetProperties()
	foreach ($item in $prop.ChildNodes) {
		if ($item.Name -eq 'TscToolPath') {
			if (($item.Condition.Contains("(TscToolPath)"))) {
				$item.InnerXml = '$(MSBuildThisFileDirectory)\..\..\..\Microsoft SDKs\TypeScript';
			}
		}
	}
}

$xml.Save((Resolve-Path '.\Microsoft\VisualStudio\TypeScript\Microsoft.TypeScript.targets'))
