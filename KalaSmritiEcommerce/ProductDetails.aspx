<%@ Page Title="Product Details" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeFile="ProductDetails.aspx.cs" Inherits="ProductDetails" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="bg-stone-50 min-h-screen py-12">
        <div class="container mx-auto px-4 max-w-6xl">
            
            <asp:Panel ID="pnlNotFound" runat="server" Visible="false" CssClass="bg-white border border-stone-200 p-16 text-center shadow-sm">
                <i class="fas fa-feather-alt text-amber-200 text-5xl mb-6"></i>
                <h2 class="font-heritage text-3xl text-stone-800 mb-4 uppercase tracking-tighter">Treasures Elusive</h2>
                <p class="font-serif-italic text-stone-500 mb-8 max-w-md mx-auto">The masterpiece you seek is currently not in our physical or digital gallery.</p>
                <a href="Shop.aspx" class="inline-block bg-amber-900 text-white px-10 py-4 text-[10px] font-bold uppercase tracking-[0.3em] hover:bg-amber-800 transition shadow-xl">Return to Gallery</a>
            </asp:Panel>

            <asp:Panel ID="pnlProduct" runat="server" Visible="false">
                <div class="grid grid-cols-1 lg:grid-cols-12 gap-12 items-start">
                    
                    <div class="lg:col-span-7 bg-white border border-stone-200 p-4 shadow-sm group">
                        <div class="relative overflow-hidden aspect-square bg-stone-100">
                            <asp:Image ID="imgProduct" runat="server" CssClass="w-full h-full object-cover transition-transform duration-1000 group-hover:scale-110" />
                        </div>
                    </div>

                    <div class="lg:col-span-5 space-y-8">
                        <div>
                            <p class="text-[10px] text-amber-700 font-bold uppercase tracking-[0.4em] mb-3">
                                <asp:Label ID="lblCategory" runat="server"></asp:Label>
                            </p>
                            <h1 class="font-heritage text-4xl text-stone-900 mb-4 uppercase tracking-tighter leading-tight">
                                <asp:Label ID="lblProductName" runat="server"></asp:Label>
                            </h1>

                            <div class="flex items-baseline gap-4 mb-6">
                                <asp:Label ID="lblPrice" runat="server" CssClass="text-2xl font-heritage text-amber-900"></asp:Label>
                                <asp:Label ID="lblOriginalPrice" runat="server" CssClass="text-stone-300 line-through text-sm italic"></asp:Label>
                            </div>

                            <div class="prose prose-stone">
                                <p class="font-serif-italic text-stone-600 leading-relaxed text-base italic border-l-2 border-stone-100 pl-6">
                                    <asp:Label ID="lblDescription" runat="server"></asp:Label>
                                </p>
                            </div>
                        </div>

                        <div class="grid grid-cols-2 gap-4 py-6 border-y border-stone-100">
                            <div>
                                <span class="block text-[9px] font-bold uppercase tracking-widest text-stone-400 mb-1">Availability</span>
                                <asp:Label ID="lblStock" runat="server" CssClass="text-xs font-bold text-stone-800 uppercase tracking-widest"></asp:Label>
                            </div>
                            <div>
                                <span class="block text-[9px] font-bold uppercase tracking-widest text-stone-400 mb-1">Certification</span>
                                <span class="text-xs font-bold text-amber-800 uppercase tracking-widest">Handcrafted Original</span>
                            </div>
                        </div>

                        <div class="flex items-center justify-between p-5 bg-stone-100/50 border border-stone-200 shadow-inner">
                            <div>
                                <span class="block text-[9px] font-bold uppercase tracking-widest text-stone-400 mb-1">Curation Merit</span>
                                <asp:Label ID="lblAverageRating" runat="server" CssClass="text-stone-800 font-heritage text-lg"></asp:Label>
                            </div>
                            <asp:Label ID="lblRatingSummary" runat="server" CssClass="text-[10px] text-stone-500 italic uppercase tracking-wider"></asp:Label>
                        </div>

                        <div class="space-y-4 pt-4">
                            <asp:Button ID="btnAddToCart" runat="server" Text="Acquire Piece" OnClick="btnAddToCart_Click"
                                CssClass="w-full bg-amber-900 text-white py-5 text-[11px] font-bold uppercase tracking-[0.3em] hover:bg-amber-800 transition shadow-lg cursor-pointer border-none" />
                            
                            <div class="flex items-center justify-center gap-6 pt-2">
                                <a href="Shop.aspx" class="text-[10px] font-bold uppercase tracking-widest text-stone-400 hover:text-amber-900 transition flex items-center">
                                    <i class="fas fa-arrow-left mr-2 text-[8px]"></i> Return to Gallery
                                </a>
                                <span class="text-stone-200">|</span>
                                <a href="Cart.aspx" class="text-[10px] font-bold uppercase tracking-widest text-stone-400 hover:text-amber-900 transition flex items-center">
                                    View Selection <i class="fas fa-shopping-bag ml-2 text-[8px]"></i>
                                </a>
                            </div>
                        </div>

                        <asp:Panel ID="pnlMessage" runat="server" Visible="false" CssClass="mt-6 p-4 border border-amber-200 bg-amber-50 text-amber-900 text-[10px] font-bold uppercase tracking-widest text-center">
                            <asp:Label ID="lblMessage" runat="server"></asp:Label>
                        </asp:Panel>
                    </div>
                </div>

                <div class="mt-20">
                    <div class="flex items-center gap-6 mb-12">
                        <h2 class="font-heritage text-2xl text-amber-900 uppercase tracking-widest">Collector Observations</h2>
                        <div class="h-[1px] flex-grow bg-stone-200"></div>
                    </div>

                    <div class="grid grid-cols-1 md:grid-cols-2 gap-8">
                        <asp:Repeater ID="rptReviews" runat="server">
                            <ItemTemplate>
                                <div class="bg-white border border-stone-200 p-8 relative shadow-sm">
                                    <div class="flex justify-between items-start mb-4">
                                        <div>
                                            <p class="text-stone-800 text-[10px] font-bold uppercase tracking-widest"><%# Eval("FirstName") %></p>
                                            <p class="text-[9px] text-stone-400 italic"><%# string.Format("{0:MMMM dd, yyyy}", Eval("ReviewDate")) %></p>
                                        </div>
                                        <div class="text-amber-600 text-[8px] tracking-[0.2em]">
                                            <%# GetStars(Convert.ToInt32(Eval("Rating"))) %>
                                        </div>
                                    </div>
                                    <p class="text-stone-600 text-sm font-serif-italic leading-relaxed italic">"<%# Eval("ReviewText") %>"</p>
                                </div>
                            </ItemTemplate>
                        </asp:Repeater>
                    </div>

                    <asp:Panel ID="pnlNoReviews" runat="server" Visible="false" CssClass="text-center py-12 border border-dashed border-stone-300">
                        <p class="text-stone-400 text-xs italic uppercase tracking-widest">No observations recorded for this piece.</p>
                    </asp:Panel>
                </div>
            </asp:Panel>
        </div>
    </div>
</asp:Content>