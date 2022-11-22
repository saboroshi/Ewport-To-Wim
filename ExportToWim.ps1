function ButtonWorkFolder-Click
{
    $OpenFileDialog.Filter = "Windows Image file (*.esd; *.wim)|*.esd;*.wim|All file (*.*)|*.*"
    $OpenFileDialog.ShowDialog()
    $TextBoxSourceImageFile.Text = $OpenFileDialog.FileName
    $SourceImagePath = $TextBoxSourceImageFile.Text
	$Data = Get-WindowsImage -ImagePath "$SourceImagePath"
	$OutputList = New-Object System.Collections.ArrayList
	$OutputList.AddRange(@($Data | Select-Object ImageName, ImageIndex))
	$DataGridView.AutoSizeColumnsMode = 'Fill'
	$DataGridView.DataSource = $OutputList
}

function DataGridView-RowHeaderMouseClick
{
    $TextBoxSelectedImageName.Text = $datagridview.SelectedCells.Item(0).Value
	$TextBoxSelectedImageIndex.Text = $datagridview.SelectedCells.Item(1).Value
}

function ButtonDestinationImagePath-Click
{
    $SaveFileDialog.Filter = "Windows Image file (*.wim)|*.wim"
    $SaveFileDialog.FileName = "install.wim"
    $SaveFileDialog.ShowDialog()
    $TextBoxDestinationImagePath.Text = $SaveFileDialog.FileName  
}

function ComboBoxCompression-Click
{
    $ComboBoxCompression.Items.Clear()
    $ComboBoxCompression.Items.Add("None")
    $ComboBoxCompression.Items.Add("Fast")
    $ComboBoxCompression.Items.Add("Maximum")
}

function ButtonExport-Click
{
    $SourceImageFile = $TextBoxSourceImageFile.Text
	$SourceIndex = $TextBoxSelectedImageIndex.Text
	$DestImagePath = $TextBoxDestinationImagePath.Text
	$DestinationName = $TextBoxSelectedImageName.Text
	$Compression = $ComboBoxCompression.Text
    $Form.Enabled = $false
    [void] [System.Windows.MessageBox]::Show('This operation may take several minutes. When the operation is finished, the program interface becomes active again.','Information','OK')
    Export-WindowsImage -SourceImagePath "$SourceImageFile" -SourceIndex "$SourceIndex" `
						          -DestinationImagePath "$DestImagePath" -DestinationName "$DestinationName" `
						          -CompressionType "$Compression"
    $Form.Enabled = $true
}

[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Drawing") 
[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")
[void] [Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")
[System.Windows.Forms.Application]::EnableVisualStyles()

$Form = New-Object System.Windows.Forms.Form 
$Form.Text = "Export To WIM:"
$Form.Size = New-Object System.Drawing.Size(400,400) 
$Form.StartPosition = "CenterScreen"

$LabelSourceImageFile = New-Object System.Windows.Forms.Label
$LabelSourceImageFile.Location = New-Object System.Drawing.Size(10,12) 
$LabelSourceImageFile.Size = New-Object System.Drawing.Size(100,20) 
$LabelSourceImageFile.Text = "Source image file:"
$Form.Controls.Add($LabelSourceImageFile)

$TextBoxSourceImageFile = New-Object System.Windows.Forms.TextBox 
$TextBoxSourceImageFile.Location = New-Object System.Drawing.Size(120,10) 
$TextBoxSourceImageFile.Size = New-Object System.Drawing.Size(250,20) 
$Form.Controls.Add($TextBoxSourceImageFile)

$ButtonSourceImageFile = New-Object System.Windows.Forms.Button
$ButtonSourceImageFile.Location = New-Object System.Drawing.Size(295,35)
$ButtonSourceImageFile.Size = New-Object System.Drawing.Size(75,23)
$ButtonSourceImageFile.Text = "Browse"
$ButtonSourceImageFile.Add_Click({ButtonWorkFolder-Click})
$Form.Controls.Add($ButtonSourceImageFile)

$DataGridView = New-Object System.Windows.Forms.DataGridView
$DataGridView.Location = New-Object System.Drawing.Size(10,65)
$DataGridView.Size = New-Object System.Drawing.Size(360,140)
$DataGridView.Add_RowHeaderMouseClick({DataGridView-RowHeaderMouseClick})
$Form.Controls.Add($DataGridView)

$LabelSelectedImageName = New-Object System.Windows.Forms.Label
$LabelSelectedImageName.Location = New-Object System.Drawing.Size(10,223) 
$LabelSelectedImageName.Size = New-Object System.Drawing.Size(120,20) 
$LabelSelectedImageName.Text = "Selected image name:"
$Form.Controls.Add($LabelSelectedImageName)

$TextBoxSelectedImageName = New-Object System.Windows.Forms.TextBox 
$TextBoxSelectedImageName.Location = New-Object System.Drawing.Size(140,220) 
$TextBoxSelectedImageName.Size = New-Object System.Drawing.Size(150,20) 
#$TextBoxSelectedImageName.Enabled = $false
$Form.Controls.Add($TextBoxSelectedImageName)

$LabelSelectedImageIndex = New-Object System.Windows.Forms.Label
$LabelSelectedImageIndex.Location = New-Object System.Drawing.Size(290,223) 
$LabelSelectedImageIndex.Size = New-Object System.Drawing.Size(40,20) 
$LabelSelectedImageIndex.Text = "Index:"
$Form.Controls.Add($LabelSelectedImageIndex)

$TextBoxSelectedImageIndex = New-Object System.Windows.Forms.TextBox 
$TextBoxSelectedImageIndex.Location = New-Object System.Drawing.Size(330,220) 
$TextBoxSelectedImageIndex.Size = New-Object System.Drawing.Size(40,20)
#$TextBoxSelectedImageIndex.Enabled = $false
$Form.Controls.Add($TextBoxSelectedImageIndex)

$LabelDestinationImagePath = New-Object System.Windows.Forms.Label
$LabelDestinationImagePath.Location = New-Object System.Drawing.Size(10,253) 
$LabelDestinationImagePath.Size = New-Object System.Drawing.Size(130,20) 
$LabelDestinationImagePath.Text = "Destination image path:"
$Form.Controls.Add($LabelDestinationImagePath)

$TextBoxDestinationImagePath = New-Object System.Windows.Forms.TextBox 
$TextBoxDestinationImagePath.Location = New-Object System.Drawing.Size(140,250) 
$TextBoxDestinationImagePath.Size = New-Object System.Drawing.Size(230,20)
$Form.Controls.Add($TextBoxDestinationImagePath)

$ButtonDestinationImagePath = New-Object System.Windows.Forms.Button
$ButtonDestinationImagePath.Location = New-Object System.Drawing.Size(295,280)
$ButtonDestinationImagePath.Size = New-Object System.Drawing.Size(75,23)
$ButtonDestinationImagePath.Text = "Browse"
$ButtonDestinationImagePath.Add_Click({ButtonDestinationImagePath-Click})
$Form.Controls.Add($ButtonDestinationImagePath)

$LabelCompression = New-Object System.Windows.Forms.Label
$LabelCompression.Location = New-Object System.Drawing.Size(10,283) 
$LabelCompression.Size = New-Object System.Drawing.Size(100,20) 
$LabelCompression.Text = "Compression:"
$Form.Controls.Add($LabelCompression)

$ComboBoxCompression = New-Object System.Windows.Forms.ComboBox 
$ComboBoxCompression.Location = New-Object System.Drawing.Size(140,280) 
$ComboBoxCompression.Size = New-Object System.Drawing.Size(100,20)
$ComboBoxCompression.Add_Click({ComboBoxCompression-Click})

$Form.Controls.Add($ComboBoxCompression)

$ButtonExport = New-Object System.Windows.Forms.Button
$ButtonExport.Location = New-Object System.Drawing.Size(150,320)
$ButtonExport.Size = New-Object System.Drawing.Size(75,23)
$ButtonExport.Text = "Export"
$ButtonExport.Add_Click({ButtonExport-Click})
$Form.Controls.Add($ButtonExport)

$OpenFileDialog = New-Object System.Windows.Forms.OpenFileDialog
$SaveFileDialog = New-Object System.Windows.Forms.SaveFileDialog

[void] $Form.ShowDialog()
