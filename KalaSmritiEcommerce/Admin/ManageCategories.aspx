<%@ Page Title="Manage Categories" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeFile="ManageCategories.aspx.cs" Inherits="Admin_ManageCategories" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <section class="bg-stone-50 min-h-screen py-14 md:py-20">
        <div class="container mx-auto px-4">
            <div class="max-w-6xl mx-auto space-y-8">
                <div class="flex flex-col md:flex-row md:items-end md:justify-between gap-4">
                    <div>
                        <p class="text-[10px] font-bold uppercase tracking-[0.4em] text-amber-700 mb-3">Admin Console</p>
                        <h1 class="font-heritage text-3xl md:text-4xl text-stone-900 uppercase tracking-[0.08em]">Collections</h1>
                        <p class="font-serif-italic text-stone-500 text-sm mt-3">Shape category structures and discovery paths.</p>
                    </div>
                    <a href="Dashboard.aspx" class="inline-block border border-stone-300 text-stone-600 px-5 py-2 text-[10px] font-bold uppercase tracking-[0.2em] hover:border-amber-800 hover:text-amber-900 transition-colors">Back to Dashboard</a>
                </div>

                <div class="bg-white border border-stone-200 shadow-sm p-6 md:p-8">
                    <div class="border-b border-stone-100 pb-4 mb-6">
                        <h2 class="font-heritage text-xl text-stone-800 uppercase tracking-[0.08em]">Category Form</h2>
                    </div>
                    <asp:Panel ID="pnlMessage" runat="server" Visible="false" CssClass="mb-4 p-3 rounded-lg">
                        <asp:Label ID="lblMessage" runat="server"></asp:Label>
                    </asp:Panel>

                    <asp:HiddenField ID="hfEditingCategoryId" runat="server" Value="" />

                    <div class="grid grid-cols-1 md:grid-cols-2 gap-5">
                        <div>
                            <label class="block text-[10px] font-bold uppercase tracking-[0.2em] text-stone-400 mb-2">Category Name</label>
                            <asp:TextBox ID="txtCategoryName" runat="server" CssClass="w-full px-4 py-3 border border-stone-200 bg-white text-sm text-stone-700 focus:outline-none focus:border-amber-800"></asp:TextBox>
                        </div>
                        <div>
                            <label class="block text-[10px] font-bold uppercase tracking-[0.2em] text-stone-400 mb-2">Image URL</label>
                            <asp:TextBox ID="txtImageUrl" runat="server" CssClass="w-full px-4 py-3 border border-stone-200 bg-white text-sm text-stone-700 focus:outline-none focus:border-amber-800" placeholder="/Images/categories/new-category.jpg"></asp:TextBox>
                        </div>
                        <div class="md:col-span-2">
                            <label class="block text-[10px] font-bold uppercase tracking-[0.2em] text-stone-400 mb-2">Description</label>
                            <asp:TextBox ID="txtDescription" runat="server" TextMode="MultiLine" Rows="3" CssClass="w-full px-4 py-3 border border-stone-200 bg-white text-sm text-stone-700 focus:outline-none focus:border-amber-800"></asp:TextBox>
                        </div>
                    </div>

                    <div class="mt-6 flex flex-wrap items-center gap-2">
                        <asp:CheckBox ID="chkCategoryActive" runat="server" Text=" Active" Checked="true" CssClass="text-sm text-stone-600" />
                        <asp:Button ID="btnAddCategory" runat="server" Text="Add Category" OnClick="btnAddCategory_Click"
                            CssClass="bg-amber-900 text-white px-6 py-3 text-[10px] font-bold uppercase tracking-[0.2em] hover:bg-amber-800 transition cursor-pointer" />
                        <asp:Button ID="btnUpdateCategory" runat="server" Text="Update Category" OnClick="btnUpdateCategory_Click" Visible="false"
                            CssClass="bg-stone-700 text-white px-6 py-3 text-[10px] font-bold uppercase tracking-[0.2em] hover:bg-stone-600 transition cursor-pointer" />
                        <asp:Button ID="btnCancelCategoryEdit" runat="server" Text="Cancel" OnClick="btnCancelCategoryEdit_Click" Visible="false"
                            CssClass="border border-stone-300 text-stone-600 px-6 py-3 text-[10px] font-bold uppercase tracking-[0.2em] hover:bg-stone-50 transition cursor-pointer" />
                    </div>
                </div>

                <div class="bg-white border border-stone-200 shadow-sm p-6 md:p-8">
                    <div class="border-b border-stone-100 pb-4 mb-6">
                        <h2 class="font-heritage text-xl text-stone-800 uppercase tracking-[0.08em]">Existing Categories</h2>
                    </div>
                    <div class="overflow-x-auto">
                        <asp:GridView ID="gvCategories" runat="server" AutoGenerateColumns="false" CssClass="w-full min-w-[920px]" GridLines="None" DataKeyNames="CategoryID" OnRowCommand="gvCategories_RowCommand">
                    <Columns>
                        <asp:BoundField DataField="CategoryID" HeaderText="ID" />
                        <asp:BoundField DataField="CategoryName" HeaderText="Category" />
                        <asp:BoundField DataField="Description" HeaderText="Description" />
                        <asp:BoundField DataField="IsActive" HeaderText="Active" />
                        <asp:BoundField DataField="CreatedDate" HeaderText="Created" DataFormatString="{0:yyyy-MM-dd}" />
                        <asp:TemplateField HeaderText="Actions">
                            <ItemTemplate>
                                <asp:LinkButton ID="btnEdit" runat="server" CommandName="EditCategory" CommandArgument='<%# Container.DataItemIndex %>' CssClass="text-amber-800 hover:text-stone-900 mr-3 text-[10px] font-bold uppercase tracking-widest">Edit</asp:LinkButton>
                                <asp:LinkButton ID="btnToggle" runat="server" CommandName="ToggleActive" CommandArgument='<%# Container.DataItemIndex %>' CssClass="text-stone-600 hover:text-stone-900 mr-3 text-[10px] font-bold uppercase tracking-widest">Toggle</asp:LinkButton>
                                <asp:LinkButton ID="btnDelete" runat="server" CommandName="DeleteCategory" CommandArgument='<%# Container.DataItemIndex %>' CssClass="text-red-700 hover:text-red-900 text-[10px] font-bold uppercase tracking-widest">Delete</asp:LinkButton>
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
