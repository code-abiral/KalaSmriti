<%@ Page Title="Manage Users" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeFile="ManageUsers.aspx.cs" Inherits="Admin_ManageUsers" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="bg-gray-50 min-h-screen py-8">
        <div class="container mx-auto px-4">
            <div class="flex items-center justify-between mb-6">
                <h1 class="text-3xl font-bold text-gray-800">Manage Users</h1>
                <a href="Dashboard.aspx" class="bg-gray-200 text-gray-700 px-4 py-2 rounded-lg hover:bg-gray-300 transition">Back to Dashboard</a>
            </div>

            <div class="bg-white rounded-lg shadow-md p-6">
                <asp:Panel ID="pnlMessage" runat="server" Visible="false" CssClass="mb-4 p-3 rounded-lg">
                    <asp:Label ID="lblMessage" runat="server"></asp:Label>
                </asp:Panel>

                <h2 class="text-xl font-bold text-gray-800 mb-4">User Form</h2>
                <asp:HiddenField ID="hfEditingCustomerId" runat="server" Value="" />
                <div class="grid grid-cols-1 md:grid-cols-2 gap-4 mb-4">
                    <asp:TextBox ID="txtFirstName" runat="server" CssClass="w-full px-3 py-2 border border-gray-300 rounded-lg" placeholder="First Name" />
                    <asp:TextBox ID="txtLastName" runat="server" CssClass="w-full px-3 py-2 border border-gray-300 rounded-lg" placeholder="Last Name" />
                    <asp:TextBox ID="txtEmail" runat="server" CssClass="w-full px-3 py-2 border border-gray-300 rounded-lg" placeholder="Email" TextMode="Email" />
                    <asp:TextBox ID="txtPhone" runat="server" CssClass="w-full px-3 py-2 border border-gray-300 rounded-lg" placeholder="Phone" />
                    <asp:TextBox ID="txtPassword" runat="server" CssClass="w-full px-3 py-2 border border-gray-300 rounded-lg" placeholder="Password (required for new user)" TextMode="Password" />
                    <asp:DropDownList ID="ddlFormRole" runat="server" CssClass="w-full px-3 py-2 border border-gray-300 rounded-lg">
                        <asp:ListItem Value="0" Text="User"></asp:ListItem>
                        <asp:ListItem Value="1" Text="Admin"></asp:ListItem>
                    </asp:DropDownList>
                </div>
                <div class="mb-8">
                    <asp:Button ID="btnAddUser" runat="server" Text="Add User" OnClick="btnAddUser_Click"
                        CssClass="bg-amber-600 text-white px-6 py-2 rounded-lg hover:bg-amber-700 transition font-semibold" />
                    <asp:Button ID="btnUpdateUser" runat="server" Text="Update User" OnClick="btnUpdateUser_Click" Visible="false"
                        CssClass="bg-blue-600 text-white px-6 py-2 rounded-lg hover:bg-blue-700 transition font-semibold ml-2" />
                    <asp:Button ID="btnCancelUserEdit" runat="server" Text="Cancel" OnClick="btnCancelUserEdit_Click" Visible="false"
                        CssClass="bg-gray-500 text-white px-6 py-2 rounded-lg hover:bg-gray-600 transition font-semibold ml-2" />
                </div>

                <h2 class="text-xl font-bold text-gray-800 mb-4">Existing Users</h2>

                <asp:GridView ID="gvUsers" runat="server" AutoGenerateColumns="false" CssClass="w-full" GridLines="None" DataKeyNames="CustomerID" OnRowCommand="gvUsers_RowCommand" OnRowDataBound="gvUsers_RowDataBound">
                    <Columns>
                        <asp:BoundField DataField="CustomerID" HeaderText="ID" />
                        <asp:BoundField DataField="FullName" HeaderText="Name" />
                        <asp:BoundField DataField="Email" HeaderText="Email" />
                        <asp:TemplateField HeaderText="Admin Role">
                            <ItemTemplate>
                                <asp:DropDownList ID="ddlIsAdmin" runat="server" CssClass="px-2 py-1 border border-gray-300 rounded">
                                    <asp:ListItem Value="0" Text="User"></asp:ListItem>
                                    <asp:ListItem Value="1" Text="Admin"></asp:ListItem>
                                </asp:DropDownList>
                                <asp:HiddenField ID="hfIsAdmin" runat="server" Value='<%# Convert.ToBoolean(Eval("IsAdmin")) ? "1" : "0" %>' />
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:BoundField DataField="CreatedDate" HeaderText="Created" DataFormatString="{0:yyyy-MM-dd}" />
                        <asp:TemplateField HeaderText="Actions">
                            <ItemTemplate>
                                <asp:LinkButton ID="btnEditUser" runat="server" CommandName="EditUser" CommandArgument='<%# Container.DataItemIndex %>' CssClass="text-indigo-600 hover:text-indigo-800 mr-3">Edit</asp:LinkButton>
                                <asp:LinkButton ID="btnUpdateUser" runat="server" CommandName="UpdateUserRole" CommandArgument='<%# Container.DataItemIndex %>' CssClass="text-blue-600 hover:text-blue-800">Update Role</asp:LinkButton>
                                <asp:LinkButton ID="btnDeleteUser" runat="server" CommandName="DeleteUser" CommandArgument='<%# Container.DataItemIndex %>' CssClass="text-red-600 hover:text-red-800 ml-3" OnClientClick="return confirm('Delete this user?');">Delete</asp:LinkButton>
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                    <HeaderStyle CssClass="bg-gray-100 text-gray-700 font-semibold py-3 px-4 text-left" />
                    <RowStyle CssClass="border-b border-gray-200 py-3 px-4" />
                </asp:GridView>
            </div>
        </div>
    </div>
</asp:Content>
