<%@ Page Title="Shop Heritage" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeFile="Shop.aspx.cs" Inherits="Shop" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="relative py-24 bg-[#1a140f] overflow-hidden">
        <div class="absolute inset-0 opacity-20">
            <img src="https://www.transparenttextures.com/patterns/carbon-fibre.png" class="w-full h-full object-cover" />
        </div>
        <div class="container mx-auto px-4 text-center relative z-10">
            <span class="text-amber-500 font-bold uppercase tracking-[0.4em] text-[10px] mb-4 block">The Collector's Gallery</span>
            <h1 class="font-heritage text-5xl md:text-6xl text-white mb-4 uppercase tracking-tighter">Artisanal <span class="italic text-amber-200">Heritage</span></h1>
            <p class="font-serif-italic text-amber-100/60 max-w-lg mx-auto leading-relaxed">Sourced from the heart of the Himalayas, each piece carries the soul of a thousand-year lineage.</p>
        </div>
    </div>

    <div class="bg-stone-50 min-h-screen py-12">
        <div class="container mx-auto px-4">
            <div class="grid grid-cols-1 lg:grid-cols-4 gap-12">
                
                <div class="lg:col-span-1">
                    <div class="bg-white border border-stone-200 p-8 sticky top-24 shadow-sm">
                        <h3 class="font-heritage text-xl text-amber-900 mb-8 uppercase tracking-widest border-b border-stone-100 pb-4">Refine Gallery</h3>
                        
                        <div class="mb-8">
                            <label class="block text-[10px] font-bold uppercase tracking-widest text-stone-400 mb-3">Search Collection</label>
                            <div class="flex items-center gap-2">
                                <asp:TextBox ID="txtSearch" runat="server" 
                                    CssClass="w-full px-0 py-2 border-b border-stone-200 bg-transparent focus:outline-none focus:border-amber-700 transition-colors italic text-sm text-stone-800"
                                    placeholder="e.g. Bronze Buddha..."
                                    AutoPostBack="true"
                                    OnTextChanged="ApplyFilters">
                                </asp:TextBox>
                                <asp:Button ID="btnSearchProducts" runat="server"
                                    Text="Search"
                                    OnClick="ApplyFilters"
                                    CausesValidation="false"
                                    CssClass="border border-stone-200 text-stone-500 px-4 py-2 text-[10px] font-bold uppercase tracking-widest hover:bg-stone-50 transition cursor-pointer" />
                            </div>
                        </div>

                        <div class="mb-8">
                            <label class="block text-[10px] font-bold uppercase tracking-widest text-stone-400 mb-3">Art Form</label>
                            <asp:DropDownList ID="ddlCategory" runat="server" 
                                CssClass="w-full bg-stone-50 border border-stone-100 py-3 px-3 text-xs italic text-stone-700 outline-none focus:border-amber-700"
                                AutoPostBack="true"
                                OnSelectedIndexChanged="ApplyFilters">
                            </asp:DropDownList>
                        </div>

                        <div class="mb-8">
                            <label class="block text-[10px] font-bold uppercase tracking-widest text-stone-400 mb-3">Value Range</label>
                            <asp:DropDownList ID="ddlPriceRange" runat="server" 
                                CssClass="w-full bg-stone-50 border border-stone-100 py-3 px-3 text-xs italic text-stone-700 outline-none focus:border-amber-700"
                                AutoPostBack="true"
                                OnSelectedIndexChanged="ApplyFilters">
                                <asp:ListItem Value="" Text="All Masterpieces" Selected="True"></asp:ListItem>
                                <asp:ListItem Value="0-5000" Text="Under Rs. 5,000"></asp:ListItem>
                                <asp:ListItem Value="5000-10000" Text="Rs. 5,000 - 10,000"></asp:ListItem>
                                <asp:ListItem Value="10000-20000" Text="Rs. 10,000 - 20,000"></asp:ListItem>
                                <asp:ListItem Value="20000-50000" Text="Rs. 20,000 - 50,000"></asp:ListItem>
                                <asp:ListItem Value="50000-999999" Text="Rs. 50,000 & Above"></asp:ListItem>
                            </asp:DropDownList>
                        </div>

                        <div class="mb-10">
                            <label class="block text-[10px] font-bold uppercase tracking-widest text-stone-400 mb-3">Curate By</label>
                            <asp:DropDownList ID="ddlSortBy" runat="server" 
                                CssClass="w-full bg-stone-50 border border-stone-100 py-3 px-3 text-xs italic text-stone-700 outline-none focus:border-amber-700"
                                AutoPostBack="true"
                                OnSelectedIndexChanged="ApplyFilters">
                                <asp:ListItem Value="newest" Text="Recently Unveiled" Selected="True"></asp:ListItem>
                                <asp:ListItem Value="price_asc" Text="Value: Low to High"></asp:ListItem>
                                <asp:ListItem Value="price_desc" Text="Value: High to Low"></asp:ListItem>
                                <asp:ListItem Value="name_asc" Text="Alphabetical: A to Z"></asp:ListItem>
                            </asp:DropDownList>
                        </div>

                        <asp:Button ID="btnResetFilters" runat="server" 
                            Text="Clear Curation"
                            OnClick="ResetFilters_Click"
                            CssClass="w-full border border-stone-200 text-stone-400 py-3 text-[10px] font-bold uppercase tracking-widest hover:bg-stone-50 transition cursor-pointer" />
                    </div>
                </div>

                <div class="lg:col-span-3">
                    <div class="flex justify-between items-center mb-10 pb-4 border-b border-stone-200">
                        <asp:Label ID="lblResultsCount" runat="server" CssClass="text-[10px] font-bold uppercase tracking-[0.2em] text-stone-400"></asp:Label>
                    </div>

                    <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-x-8 gap-y-12">
                        <asp:Repeater ID="rptProducts" runat="server">
                            <ItemTemplate>
                                <div class="group relative bg-white border border-stone-100 shadow-sm hover:shadow-xl transition-all duration-500">
                                    <a href='ProductDetails.aspx?id=<%# Eval("ProductID") %>' class="block overflow-hidden relative">
                                        <div class="aspect-[4/5] bg-stone-100 overflow-hidden">
                                            <img src='<%# GetProductImageUrl(Eval("ImageUrl")) %>' 
                                                 alt='<%# Eval("ProductName") %>' 
                                                 class="w-full h-full object-cover transition-transform duration-700 group-hover:scale-110"
                                                 onerror="this.src='/Images/placeholder.jpg'" />
                                        </div>
                                        
                                        <div class="absolute top-4 left-4 flex flex-col gap-2">
                                            <%# Convert.ToDecimal(Eval("DiscountPrice")) > 0 ? 
                                                "<span class='bg-red-700 text-white text-[8px] font-bold px-3 py-1 uppercase tracking-widest'>Offer</span>" : "" %>
                                            <%# Convert.ToBoolean(Eval("IsFeatured")) ? 
                                                "<span class='bg-amber-900 text-white text-[8px] font-bold px-3 py-1 uppercase tracking-widest'>Featured</span>" : "" %>
                                        </div>

                                        <%# Convert.ToInt32(Eval("StockQuantity")) == 0 ? 
                                            "<div class='absolute inset-0 bg-stone-900/40 backdrop-blur-[2px] flex items-center justify-center'><span class='text-white font-heritage text-sm uppercase tracking-widest border border-white/30 px-6 py-2'>Out of Stock</span></div>" : "" %>
                                    </a>
                                    
                                    <div class="p-6 text-center">
                                        <p class="text-[9px] text-amber-700 font-bold uppercase tracking-[0.3em] mb-2"><%# Eval("CategoryName") %></p>
                                        <h3 class="font-heritage text-lg mb-3 text-stone-800">
                                            <a href='ProductDetails.aspx?id=<%# Eval("ProductID") %>' class="hover:text-amber-900 transition-colors">
                                                <%# Eval("ProductName") %>
                                            </a>
                                        </h3>
                                        
                                        <div class="mb-6 font-serif-italic">
                                            <%# Convert.ToDecimal(Eval("DiscountPrice")) > 0 ? 
                                                "<span class='text-stone-300 line-through text-xs mr-2'>Rs. " + String.Format("{0:N0}", Eval("Price")) + "</span>" +
                                                "<span class='text-amber-900 font-bold text-base'>Rs. " + String.Format("{0:N0}", Eval("DiscountPrice")) + "</span>" :
                                                "<span class='text-amber-900 font-bold text-base'>Rs. " + String.Format("{0:N0}", Eval("Price")) + "</span>" %>
                                        </div>
                                        
                                        <asp:Panel ID="pnlInStock" runat="server" Visible='<%# Convert.ToInt32(Eval("StockQuantity")) > 0 %>'>
                                            <asp:LinkButton ID="btnAddToCart" runat="server"
                                                CommandName="AddToCart"
                                                CommandArgument='<%# Eval("ProductID") %>'
                                                OnCommand="AddToCart_Command"
                                                CssClass="inline-block w-full border border-amber-900 text-amber-900 py-3 text-[10px] font-bold uppercase tracking-widest hover:bg-amber-900 hover:text-white transition-all">
                                                Inquire to Cart
                                            </asp:LinkButton>
                                        </asp:Panel>
                                    </div>
                                </div>
                            </ItemTemplate>
                        </asp:Repeater>
                    </div>

                    <asp:Panel ID="pnlNoResults" runat="server" Visible="false" CssClass="text-center py-24">
                        <div class="max-w-xs mx-auto">
                            <i class="fas fa-feather-alt text-amber-200 text-5xl mb-6"></i>
                            <h3 class="font-heritage text-2xl text-stone-800 mb-2 uppercase">Empty Gallery</h3>
                            <p class="text-stone-500 text-sm font-serif-italic mb-8 leading-relaxed">The treasures you seek currently elude us. Perhaps adjust your curation?</p>
                            <asp:Button ID="btnClearFilters" runat="server" 
                                Text="Reset Curation"
                                OnClick="ResetFilters_Click"
                                CssClass="bg-amber-900 text-white px-8 py-4 text-[10px] font-bold uppercase tracking-widest hover:bg-amber-800 transition shadow-xl cursor-pointer" />
                        </div>
                    </asp:Panel>
                </div>
            </div>
        </div>
    </div>
</asp:Content>