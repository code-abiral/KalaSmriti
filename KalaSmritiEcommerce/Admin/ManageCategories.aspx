<%@ Page Title="Manage Categories" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeFile="ManageCategories.aspx.cs" Inherits="Admin_ManageCategories" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="bg-gray-50 min-h-screen py-8">
        <div class="container mx-auto px-4">
            <div class="flex items-center justify-between mb-6">
                <h1 class="text-3xl font-bold text-gray-800">Manage Categories</h1>
                <a href="Dashboard.aspx" class="bg-gray-200 text-gray-700 px-4 py-2 rounded-lg hover:bg-gray-300 transition">Back to Dashboard</a>
            </div>

            <div class="bg-white rounded-lg shadow-md p-6 mb-6">
                <h2 class="text-xl font-bold text-gray-800 mb-4">Add Category</h2>
                <asp:Panel ID="pnlMessage" runat="server" Visible="false" CssClass="mb-4 p-3 rounded-lg">
                    <asp:Label ID="lblMessage" runat="server"></asp:Label>
                </asp:Panel>

                <asp:HiddenField ID="hfEditingCategoryId" runat="server" Value="" />

                <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                    <div>
                        <label class="block text-sm font-medium text-gray-700 mb-1">Category Name</label>
                        <asp:TextBox ID="txtCategoryName" runat="server" CssClass="w-full px-3 py-2 border border-gray-300 rounded-lg"></asp:TextBox>
                    </div>
                    <div>
                        <label class="block text-sm font-medium text-gray-700 mb-1">Image URL</label>
                        <asp:TextBox ID="txtImageUrl" runat="server" CssClass="w-full px-3 py-2 border border-gray-300 rounded-lg" placeholder="/Images/categories/new-category.jpg"></asp:TextBox>
                    </div>
                    <div class="md:col-span-2">
                        <label class="block text-sm font-medium text-gray-700 mb-1">Description</label>
                        <asp:TextBox ID="txtDescription" runat="server" TextMode="MultiLine" Rows="3" CssClass="w-full px-3 py-2 border border-gray-300 rounded-lg"></asp:TextBox>
                    </div>
                </div>

                <div class="mt-4 flex items-center gap-3">
                    <asp:CheckBox ID="chkCategoryActive" runat="server" Text="Active" Checked="true" CssClass="text-gray-700" />
                    <asp:Button ID="btnAddCategory" runat="server" Text="Add Category" OnClick="btnAddCategory_Click"
                        CssClass="bg-amber-600 text-white px-6 py-2 rounded-lg hover:bg-amber-700 transition font-semibold" />
                    <asp:Button ID="btnUpdateCategory" runat="server" Text="Update Category" OnClick="btnUpdateCategory_Click" Visible="false"
                        CssClass="bg-blue-600 text-white px-6 py-2 rounded-lg hover:bg-blue-700 transition font-semibold" />
                    <asp:Button ID="btnCancelCategoryEdit" runat="server" Text="Cancel" OnClick="btnCancelCategoryEdit_Click" Visible="false"
                        CssClass="bg-gray-500 text-white px-6 py-2 rounded-lg hover:bg-gray-600 transition font-semibold" />
                </div>
            </div>

            <div class="bg-white rounded-lg shadow-md p-6">
                <h2 class="text-xl font-bold text-gray-800 mb-4">Existing Categories</h2>
                <asp:GridView ID="gvCategories" runat="server" AutoGenerateColumns="false" CssClass="w-full" GridLines="None" DataKeyNames="CategoryID" OnRowCommand="gvCategories_RowCommand">
                    <Columns>
                        <asp:BoundField DataField="CategoryID" HeaderText="ID" />
                        <asp:BoundField DataField="CategoryName" HeaderText="Category" />
                        <asp:BoundField DataField="Description" HeaderText="Description" />
                        <asp:BoundField DataField="IsActive" HeaderText="Active" />
                        <asp:BoundField DataField="CreatedDate" HeaderText="Created" DataFormatString="{0:yyyy-MM-dd}" />
                        <asp:TemplateField HeaderText="Actions">
                            <ItemTemplate>
                                <asp:LinkButton ID="btnEdit" runat="server" CommandName="EditCategory" CommandArgument='<%# Container.DataItemIndex %>' CssClass="text-indigo-600 hover:text-indigo-800 mr-3">Edit</asp:LinkButton>
                                <asp:LinkButton ID="btnToggle" runat="server" CommandName="ToggleActive" CommandArgument='<%# Container.DataItemIndex %>' CssClass="text-blue-600 hover:text-blue-800 mr-3">Toggle Active</asp:LinkButton>
                                <asp:LinkButton ID="btnDelete" runat="server" CommandName="DeleteCategory" CommandArgument='<%# Container.DataItemIndex %>' CssClass="text-red-600 hover:text-red-800">Delete</asp:LinkButton>
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
