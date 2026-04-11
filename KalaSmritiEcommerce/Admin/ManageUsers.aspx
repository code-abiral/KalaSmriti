<%@ Page Title="Manage Users" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeFile="ManageUsers.aspx.cs" Inherits="Admin_ManageUsers" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <section class="bg-stone-50 min-h-screen py-14 md:py-20">
        <div class="container mx-auto px-4">
            <div class="max-w-6xl mx-auto space-y-8">
                <div class="flex flex-col md:flex-row md:items-end md:justify-between gap-4">
                    <div>
                        <p class="text-[10px] font-bold uppercase tracking-[0.4em] text-amber-700 mb-3">Admin Console</p>
                        <h1 class="font-heritage text-3xl md:text-4xl text-stone-900 uppercase tracking-[0.08em]">Access Keys</h1>
                        <p class="font-serif-italic text-stone-500 text-sm mt-3">Manage identities, roles, and account privileges.</p>
                    </div>
                    <a href="Dashboard.aspx" class="inline-block border border-stone-300 text-stone-600 px-5 py-2 text-[10px] font-bold uppercase tracking-[0.2em] hover:border-amber-800 hover:text-amber-900 transition-colors">Back to Dashboard</a>
                </div>

                <div class="bg-white border border-stone-200 shadow-sm p-6 md:p-8">
                    <asp:Panel ID="pnlMessage" runat="server" Visible="false" CssClass="mb-4 p-3 rounded-lg">
                        <asp:Label ID="lblMessage" runat="server"></asp:Label>
                    </asp:Panel>

                    <div class="border-b border-stone-100 pb-4 mb-6">
                        <h2 class="font-heritage text-xl text-stone-800 uppercase tracking-[0.08em]">User Form</h2>
                    </div>
                    <asp:HiddenField ID="hfEditingCustomerId" runat="server" Value="" />
                    <div class="grid grid-cols-1 md:grid-cols-2 gap-5 mb-6">
                        <asp:TextBox ID="txtFirstName" runat="server" CssClass="w-full px-4 py-3 border border-stone-200 bg-white text-sm text-stone-700 focus:outline-none focus:border-amber-800" placeholder="First Name" />
                        <asp:TextBox ID="txtLastName" runat="server" CssClass="w-full px-4 py-3 border border-stone-200 bg-white text-sm text-stone-700 focus:outline-none focus:border-amber-800" placeholder="Last Name" />
                        <asp:TextBox ID="txtEmail" runat="server" CssClass="w-full px-4 py-3 border border-stone-200 bg-white text-sm text-stone-700 focus:outline-none focus:border-amber-800" placeholder="Email" TextMode="Email" />
                        <asp:TextBox ID="txtPhone" runat="server" CssClass="w-full px-4 py-3 border border-stone-200 bg-white text-sm text-stone-700 focus:outline-none focus:border-amber-800" placeholder="Phone" />
                        <asp:TextBox ID="txtPassword" runat="server" CssClass="w-full px-4 py-3 border border-stone-200 bg-white text-sm text-stone-700 focus:outline-none focus:border-amber-800" placeholder="Password (required for new user)" TextMode="Password" />
                        <asp:DropDownList ID="ddlFormRole" runat="server" CssClass="w-full px-4 py-3 border border-stone-200 bg-white text-sm text-stone-700 focus:outline-none focus:border-amber-800">
                            <asp:ListItem Value="0" Text="User"></asp:ListItem>
                            <asp:ListItem Value="1" Text="Admin"></asp:ListItem>
                        </asp:DropDownList>
                    </div>
                    <div class="mb-8 flex flex-wrap gap-2">
                        <asp:Button ID="btnAddUser" runat="server" Text="Add User" OnClick="btnAddUser_Click"
                            CssClass="bg-amber-900 text-white px-6 py-3 text-[10px] font-bold uppercase tracking-[0.2em] hover:bg-amber-800 transition cursor-pointer" />
                        <asp:Button ID="btnUpdateUser" runat="server" Text="Update User" OnClick="btnUpdateUser_Click" Visible="false"
                            CssClass="bg-stone-700 text-white px-6 py-3 text-[10px] font-bold uppercase tracking-[0.2em] hover:bg-stone-600 transition cursor-pointer" />
                        <asp:Button ID="btnCancelUserEdit" runat="server" Text="Cancel" OnClick="btnCancelUserEdit_Click" Visible="false"
                            CssClass="border border-stone-300 text-stone-600 px-6 py-3 text-[10px] font-bold uppercase tracking-[0.2em] hover:bg-stone-50 transition cursor-pointer" />
                    </div>

                    <div class="border-b border-stone-100 pb-4 mb-6">
                        <h2 class="font-heritage text-xl text-stone-800 uppercase tracking-[0.08em]">Existing Users</h2>
                    </div>

                    <div class="overflow-x-auto">
                        <asp:GridView ID="gvUsers" runat="server" AutoGenerateColumns="false" CssClass="w-full min-w-[980px]" GridLines="None" DataKeyNames="CustomerID" OnRowCommand="gvUsers_RowCommand" OnRowDataBound="gvUsers_RowDataBound">
                    <Columns>
                        <asp:BoundField DataField="CustomerID" HeaderText="ID" />
                        <asp:BoundField DataField="FullName" HeaderText="Name" />
                        <asp:BoundField DataField="Email" HeaderText="Email" />
                        <asp:TemplateField HeaderText="Admin Role">
                            <ItemTemplate>
                                <asp:DropDownList ID="ddlIsAdmin" runat="server" CssClass="px-3 py-2 border border-stone-200 bg-white text-sm text-stone-700 focus:outline-none focus:border-amber-800">
                                    <asp:ListItem Value="0" Text="User"></asp:ListItem>
                                    <asp:ListItem Value="1" Text="Admin"></asp:ListItem>
                                </asp:DropDownList>
                                <asp:HiddenField ID="hfIsAdmin" runat="server" Value='<%# Convert.ToBoolean(Eval("IsAdmin")) ? "1" : "0" %>' />
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:BoundField DataField="CreatedDate" HeaderText="Created" DataFormatString="{0:yyyy-MM-dd}" />
                        <asp:TemplateField HeaderText="Actions">
                            <ItemTemplate>
                                <asp:LinkButton ID="btnEditUser" runat="server" CommandName="EditUser" CommandArgument='<%# Container.DataItemIndex %>' CssClass="text-amber-800 hover:text-stone-900 mr-3 text-[10px] font-bold uppercase tracking-widest">Edit</asp:LinkButton>
                                <asp:LinkButton ID="btnUpdateUser" runat="server" CommandName="UpdateUserRole" CommandArgument='<%# Container.DataItemIndex %>' CssClass="text-stone-600 hover:text-stone-900 text-[10px] font-bold uppercase tracking-widest">Update Role</asp:LinkButton>
                                <asp:LinkButton ID="btnDeleteUser" runat="server" CommandName="DeleteUser" CommandArgument='<%# Container.DataItemIndex %>' CssClass="text-red-700 hover:text-red-900 ml-3 text-[10px] font-bold uppercase tracking-widest" OnClientClick="return confirm('Delete this user?');">Delete</asp:LinkButton>
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                    <HeaderStyle CssClass="bg-stone-50 border-y border-stone-100 text-[10px] uppercase tracking-[0.2em] text-stone-500 font-bold text-left" />
                    <RowStyle CssClass="border-b border-stone-100 text-sm text-stone-700" />
                </asp:GridView>
                    </div>
                </div>
            </div>
        </div>
    </section>
</asp:Content>
