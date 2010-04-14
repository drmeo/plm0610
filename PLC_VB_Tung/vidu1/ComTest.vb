Public Class FrmCom

    Private Sub Form1_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load
        Com1.Open()
        Com1.BaudRate = 9600
        Com1.Parity = IO.Ports.Parity.None
        Com1.DataBits = 8
        Com1.StopBits = IO.Ports.StopBits.One





    End Sub

    Private Sub BtGui_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles BtGui.Click
        Com1.Write(TxtGui.Text)


    End Sub

    Private Sub BtNhan_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles BtNhan.Click
        TxtNhan.Text = Com1.ReadExisting()

    End Sub

    Private Sub BtXoa_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles BtXoa.Click
        TxtGui.Text = ""
        TxtNhan.Text = ""
        Com1.DiscardInBuffer()
        Com1.DiscardOutBuffer()



    End Sub

    Private Sub BtThoat_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles BtThoat.Click
        Me.Close()
        Com1.Close()

    End Sub

    Private Sub ExitToolStripMenuItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs)
        Me.Close()
        Com1.Close()

    End Sub

    Private Sub ExitToolStripMenuItem_Click_1(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles ExitToolStripMenuItem.Click
        Me.Close()
        Com1.Close()

    End Sub

   
    Private Sub Com1_DataReceived(ByVal sender As System.Object, ByVal e As System.IO.Ports.SerialDataReceivedEventArgs) Handles Com1.DataReceived
        Control.CheckForIllegalCrossThreadCalls = False
        TxtNhan.Text = TxtNhan.Text + Com1.ReadExisting


    End Sub
End Class
