<%@ Page Title="Manage Products" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeFile="ManageProducts.aspx.cs" Inherits="Admin_ManageProducts" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <section class="bg-stone-50 min-h-screen py-14 md:py-20">
        <div class="container mx-auto px-4">
            <div class="max-w-6xl mx-auto space-y-8">
                <div class="flex flex-col md:flex-row md:items-end md:justify-between gap-4">
                    <div>
                        <p class="text-[10px] font-bold uppercase tracking-[0.4em] text-amber-700 mb-3">Admin Console</p>
                        <h1 class="font-heritage text-3xl md:text-4xl text-stone-900 uppercase tracking-[0.08em]">Stock Assets</h1>
                        <p class="font-serif-italic text-stone-500 text-sm mt-3">Manage pricing, inventory, and catalog presentation.</p>
                    </div>
                    <a href="Dashboard.aspx" class="inline-block border border-stone-300 text-stone-600 px-5 py-2 text-[10px] font-bold uppercase tracking-[0.2em] hover:border-amber-800 hover:text-amber-900 transition-colors">Back to Dashboard</a>
                </div>

                <div class="bg-white border border-stone-200 shadow-sm p-6 md:p-8">
                    <div class="border-b border-stone-100 pb-4 mb-6">
                        <h2 class="font-heritage text-xl text-stone-800 uppercase tracking-[0.08em]">Product Form</h2>
                    </div>
                    <asp:Panel ID="pnlMessage" runat="server" Visible="false" CssClass="mb-4 p-3 rounded-lg">
                        <asp:Label ID="lblMessage" runat="server"></asp:Label>
                    </asp:Panel>

                    <asp:HiddenField ID="hfEditingProductId" runat="server" Value="" />

                    <div class="grid grid-cols-1 md:grid-cols-2 gap-5">
                        <div>
                            <label class="block text-[10px] font-bold uppercase tracking-[0.2em] text-stone-400 mb-2">Product Name</label>
                            <asp:TextBox ID="txtProductName" runat="server" CssClass="w-full px-4 py-3 border border-stone-200 bg-white text-sm text-stone-700 focus:outline-none focus:border-amber-800" />
                        </div>
                        <div>
                            <label class="block text-[10px] font-bold uppercase tracking-[0.2em] text-stone-400 mb-2">Category</label>
                            <asp:DropDownList ID="ddlCategory" runat="server" CssClass="w-full px-4 py-3 border border-stone-200 bg-white text-sm text-stone-700 focus:outline-none focus:border-amber-800"></asp:DropDownList>
                        </div>
                        <div>
                            <label class="block text-[10px] font-bold uppercase tracking-[0.2em] text-stone-400 mb-2">Price</label>
                            <asp:TextBox ID="txtPrice" runat="server" CssClass="w-full px-4 py-3 border border-stone-200 bg-white text-sm text-stone-700 focus:outline-none focus:border-amber-800" TextMode="Number" />
                        </div>
                        <div>
                            <label class="block text-[10px] font-bold uppercase tracking-[0.2em] text-stone-400 mb-2">Discount Price</label>
                            <asp:TextBox ID="txtDiscountPrice" runat="server" CssClass="w-full px-4 py-3 border border-stone-200 bg-white text-sm text-stone-700 focus:outline-none focus:border-amber-800" TextMode="Number" />
                        </div>
                        <div>
                            <label class="block text-[10px] font-bold uppercase tracking-[0.2em] text-stone-400 mb-2">Stock Quantity</label>
                            <asp:TextBox ID="txtStockQuantity" runat="server" CssClass="w-full px-4 py-3 border border-stone-200 bg-white text-sm text-stone-700 focus:outline-none focus:border-amber-800" TextMode="Number" />
                        </div>
                        <div>
                            <label class="block text-[10px] font-bold uppercase tracking-[0.2em] text-stone-400 mb-2">Upload Image</label>
                            <asp:FileUpload ID="fuProductImage" runat="server" CssClass="w-full px-4 py-3 border border-stone-200 bg-white text-sm text-stone-700" />
                        </div>
                        <div class="md:col-span-2">
                            <label class="block text-[10px] font-bold uppercase tracking-[0.2em] text-stone-400 mb-2">Description</label>
                            <asp:TextBox ID="txtDescription" runat="server" CssClass="w-full px-4 py-3 border border-stone-200 bg-white text-sm text-stone-700 focus:outline-none focus:border-amber-800" TextMode="MultiLine" Rows="4" />
                        </div>
                    </div>

                    <div class="mt-6 flex flex-wrap gap-2">
                        <asp:Button ID="btnAddProduct" runat="server" Text="Add Product" OnClick="btnAddProduct_Click"
                            CssClass="bg-amber-900 text-white px-6 py-3 text-[10px] font-bold uppercase tracking-[0.2em] hover:bg-amber-800 transition cursor-pointer" />
                        <asp:Button ID="btnUpdateProduct" runat="server" Text="Update Product" OnClick="btnUpdateProduct_Click" Visible="false"
                            CssClass="bg-stone-700 text-white px-6 py-3 text-[10px] font-bold uppercase tracking-[0.2em] hover:bg-stone-600 transition cursor-pointer" />
                        <asp:Button ID="btnCancelEdit" runat="server" Text="Cancel" OnClick="btnCancelEdit_Click" Visible="false"
                            CssClass="border border-stone-300 text-stone-600 px-6 py-3 text-[10px] font-bold uppercase tracking-[0.2em] hover:bg-stone-50 transition cursor-pointer" />
                    </div>
                </div>

                <div class="bg-white border border-stone-200 shadow-sm p-6 md:p-8">
                    <div class="border-b border-stone-100 pb-4 mb-6">
                        <h2 class="font-heritage text-xl text-stone-800 uppercase tracking-[0.08em]">Existing Products</h2>
                    </div>
                    <div class="overflow-x-auto">
                        <asp:GridView ID="gvProducts" runat="server" AutoGenerateColumns="false" CssClass="w-full min-w-[980px]" GridLines="None" DataKeyNames="ProductID" OnRowCommand="gvProducts_RowCommand">
                    <Columns>
                        <asp:BoundField DataField="ProductID" HeaderText="ID" />
                        <asp:BoundField DataField="ProductName" HeaderText="Product" />
                        <asp:BoundField DataField="CategoryName" HeaderText="Category" />
                        <asp:BoundField DataField="Price" HeaderText="Price" DataFormatString="Rs. {0:N2}" />
                        <asp:BoundField DataField="DiscountPrice" HeaderText="Discount" DataFormatString="Rs. {0:N2}" NullDisplayText="-" />
                        <asp:BoundField DataField="StockQuantity" HeaderText="Stock" />
                        <asp:BoundField DataField="IsActive" HeaderText="Active" />
                        <asp:TemplateField HeaderText="Actions">
                            <ItemTemplate>
                                <asp:LinkButton ID="btnEdit" runat="server" CommandName="EditProduct" CommandArgument='<%# Container.DataItemIndex %>' CssClass="text-amber-800 hover:text-stone-900 mr-3 text-[10px] font-bold uppercase tracking-widest">Edit</asp:LinkButton>
                                <asp:LinkButton ID="btnToggle" runat="server" CommandName="ToggleProductActive" CommandArgument='<%# Container.DataItemIndex %>' CssClass="text-stone-600 hover:text-stone-900 mr-3 text-[10px] font-bold uppercase tracking-widest">Toggle</asp:LinkButton>
                                <asp:LinkButton ID="btnDelete" runat="server" CommandName="DeleteProduct" CommandArgument='<%# Container.DataItemIndex %>' CssClass="text-red-700 hover:text-red-900 text-[10px] font-bold uppercase tracking-widest" OnClientClick="return confirm('Delete this product?');">Delete</asp:LinkButton>
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
