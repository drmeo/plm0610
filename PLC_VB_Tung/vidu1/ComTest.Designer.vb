<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class FrmCom
    Inherits System.Windows.Forms.Form

    'Form overrides dispose to clean up the component list.
    <System.Diagnostics.DebuggerNonUserCode()> _
    Protected Overrides Sub Dispose(ByVal disposing As Boolean)
        Try
            If disposing AndAlso components IsNot Nothing Then
                components.Dispose()
            End If
        Finally
            MyBase.Dispose(disposing)
        End Try
    End Sub

    'Required by the Windows Form Designer
    Private components As System.ComponentModel.IContainer

    'NOTE: The following procedure is required by the Windows Form Designer
    'It can be modified using the Windows Form Designer.  
    'Do not modify it using the code editor.
    <System.Diagnostics.DebuggerStepThrough()> _
    Private Sub InitializeComponent()
        Me.components = New System.ComponentModel.Container
        Me.Com1 = New System.IO.Ports.SerialPort(Me.components)
        Me.BtGui = New System.Windows.Forms.Button
        Me.BtNhan = New System.Windows.Forms.Button
        Me.TxtGui = New System.Windows.Forms.TextBox
        Me.TxtNhan = New System.Windows.Forms.TextBox
        Me.BtXoa = New System.Windows.Forms.Button
        Me.BtThoat = New System.Windows.Forms.Button
        Me.MenuStrip1 = New System.Windows.Forms.MenuStrip
        Me.FileToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem
        Me.OpenToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem
        Me.CloseToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem
        Me.ExitToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem
        Me.ConfigToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem
        Me.RS232ToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem
        Me.ToolsToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem
        Me.OptionsToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem
        Me.HelpToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem
        Me.MenuStrip1.SuspendLayout()
        Me.SuspendLayout()
        '
        'Com1
        '
        '
        'BtGui
        '
        Me.BtGui.Location = New System.Drawing.Point(205, 39)
        Me.BtGui.Name = "BtGui"
        Me.BtGui.Size = New System.Drawing.Size(75, 23)
        Me.BtGui.TabIndex = 0
        Me.BtGui.Text = "Gui"
        Me.BtGui.UseVisualStyleBackColor = True
        '
        'BtNhan
        '
        Me.BtNhan.Location = New System.Drawing.Point(205, 86)
        Me.BtNhan.Name = "BtNhan"
        Me.BtNhan.Size = New System.Drawing.Size(75, 23)
        Me.BtNhan.TabIndex = 1
        Me.BtNhan.Text = "Nhan"
        Me.BtNhan.UseVisualStyleBackColor = True
        '
        'TxtGui
        '
        Me.TxtGui.Location = New System.Drawing.Point(42, 42)
        Me.TxtGui.Name = "TxtGui"
        Me.TxtGui.Size = New System.Drawing.Size(122, 20)
        Me.TxtGui.TabIndex = 2
        '
        'TxtNhan
        '
        Me.TxtNhan.Location = New System.Drawing.Point(42, 89)
        Me.TxtNhan.Name = "TxtNhan"
        Me.TxtNhan.Size = New System.Drawing.Size(122, 20)
        Me.TxtNhan.TabIndex = 3
        '
        'BtXoa
        '
        Me.BtXoa.Location = New System.Drawing.Point(89, 170)
        Me.BtXoa.Name = "BtXoa"
        Me.BtXoa.Size = New System.Drawing.Size(75, 23)
        Me.BtXoa.TabIndex = 4
        Me.BtXoa.Text = "Xoa"
        Me.BtXoa.UseVisualStyleBackColor = True
        '
        'BtThoat
        '
        Me.BtThoat.Location = New System.Drawing.Point(205, 170)
        Me.BtThoat.Name = "BtThoat"
        Me.BtThoat.Size = New System.Drawing.Size(75, 23)
        Me.BtThoat.TabIndex = 5
        Me.BtThoat.Text = "Thoat"
        Me.BtThoat.UseVisualStyleBackColor = True
        '
        'MenuStrip1
        '
        Me.MenuStrip1.Items.AddRange(New System.Windows.Forms.ToolStripItem() {Me.FileToolStripMenuItem, Me.ConfigToolStripMenuItem, Me.ToolsToolStripMenuItem, Me.OptionsToolStripMenuItem, Me.HelpToolStripMenuItem})
        Me.MenuStrip1.Location = New System.Drawing.Point(0, 0)
        Me.MenuStrip1.Name = "MenuStrip1"
        Me.MenuStrip1.Size = New System.Drawing.Size(292, 24)
        Me.MenuStrip1.TabIndex = 6
        Me.MenuStrip1.Text = "MenuStrip1"
        '
        'FileToolStripMenuItem
        '
        Me.FileToolStripMenuItem.DropDownItems.AddRange(New System.Windows.Forms.ToolStripItem() {Me.OpenToolStripMenuItem, Me.CloseToolStripMenuItem, Me.ExitToolStripMenuItem})
        Me.FileToolStripMenuItem.Name = "FileToolStripMenuItem"
        Me.FileToolStripMenuItem.Size = New System.Drawing.Size(35, 20)
        Me.FileToolStripMenuItem.Text = "File"
        '
        'OpenToolStripMenuItem
        '
        Me.OpenToolStripMenuItem.Name = "OpenToolStripMenuItem"
        Me.OpenToolStripMenuItem.Size = New System.Drawing.Size(111, 22)
        Me.OpenToolStripMenuItem.Text = "Open"
        '
        'CloseToolStripMenuItem
        '
        Me.CloseToolStripMenuItem.Name = "CloseToolStripMenuItem"
        Me.CloseToolStripMenuItem.Size = New System.Drawing.Size(111, 22)
        Me.CloseToolStripMenuItem.Text = "Save"
        '
        'ExitToolStripMenuItem
        '
        Me.ExitToolStripMenuItem.Name = "ExitToolStripMenuItem"
        Me.ExitToolStripMenuItem.Size = New System.Drawing.Size(111, 22)
        Me.ExitToolStripMenuItem.Text = "Exit"
        '
        'ConfigToolStripMenuItem
        '
        Me.ConfigToolStripMenuItem.DropDownItems.AddRange(New System.Windows.Forms.ToolStripItem() {Me.RS232ToolStripMenuItem})
        Me.ConfigToolStripMenuItem.Name = "ConfigToolStripMenuItem"
        Me.ConfigToolStripMenuItem.Size = New System.Drawing.Size(50, 20)
        Me.ConfigToolStripMenuItem.Text = "Config"
        '
        'RS232ToolStripMenuItem
        '
        Me.RS232ToolStripMenuItem.Name = "RS232ToolStripMenuItem"
        Me.RS232ToolStripMenuItem.Size = New System.Drawing.Size(116, 22)
        Me.RS232ToolStripMenuItem.Text = "RS232"
        '
        'ToolsToolStripMenuItem
        '
        Me.ToolsToolStripMenuItem.Name = "ToolsToolStripMenuItem"
        Me.ToolsToolStripMenuItem.Size = New System.Drawing.Size(44, 20)
        Me.ToolsToolStripMenuItem.Text = "Tools"
        '
        'OptionsToolStripMenuItem
        '
        Me.OptionsToolStripMenuItem.Name = "OptionsToolStripMenuItem"
        Me.OptionsToolStripMenuItem.Size = New System.Drawing.Size(56, 20)
        Me.OptionsToolStripMenuItem.Text = "Options"
        '
        'HelpToolStripMenuItem
        '
        Me.HelpToolStripMenuItem.Name = "HelpToolStripMenuItem"
        Me.HelpToolStripMenuItem.Size = New System.Drawing.Size(40, 20)
        Me.HelpToolStripMenuItem.Text = "Help"
        '
        'FrmCom
        '
        Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 13.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.ClientSize = New System.Drawing.Size(292, 266)
        Me.Controls.Add(Me.BtThoat)
        Me.Controls.Add(Me.BtXoa)
        Me.Controls.Add(Me.TxtNhan)
        Me.Controls.Add(Me.TxtGui)
        Me.Controls.Add(Me.BtNhan)
        Me.Controls.Add(Me.BtGui)
        Me.Controls.Add(Me.MenuStrip1)
        Me.MainMenuStrip = Me.MenuStrip1
        Me.Name = "FrmCom"
        Me.Text = "Truyen Nhan Com Port"
        Me.MenuStrip1.ResumeLayout(False)
        Me.MenuStrip1.PerformLayout()
        Me.ResumeLayout(False)
        Me.PerformLayout()

    End Sub
    Friend WithEvents Com1 As System.IO.Ports.SerialPort
    Friend WithEvents BtGui As System.Windows.Forms.Button
    Friend WithEvents BtNhan As System.Windows.Forms.Button
    Friend WithEvents TxtGui As System.Windows.Forms.TextBox
    Friend WithEvents TxtNhan As System.Windows.Forms.TextBox
    Friend WithEvents BtXoa As System.Windows.Forms.Button
    Friend WithEvents BtThoat As System.Windows.Forms.Button
    Friend WithEvents MenuStrip1 As System.Windows.Forms.MenuStrip
    Friend WithEvents FileToolStripMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents OpenToolStripMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents CloseToolStripMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents ExitToolStripMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents ConfigToolStripMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents RS232ToolStripMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents ToolsToolStripMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents OptionsToolStripMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents HelpToolStripMenuItem As System.Windows.Forms.ToolStripMenuItem

End Class
