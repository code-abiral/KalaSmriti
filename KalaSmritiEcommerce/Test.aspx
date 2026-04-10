<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Test.aspx.cs" Inherits="Test" %>
<!DOCTYPE html>
<html>
<head>
    <title>Database Test</title>
</head>
<body>
    <h1>Database Connection Test</h1>
    <form runat="server">
        <asp:Button ID="btnTest" runat="server" Text="Test Connection" OnClick="btnTest_Click" />
        <br /><br />
        <asp:Label ID="lblResult" runat="server" Font-Size="14px"></asp:Label>
        <br /><br />
        <asp:GridView ID="gvProducts" runat="server" />
    </form>
</body>
</html>
