<%@ Page Title="Shopping Cart" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeFile="Cart.aspx.cs" Inherits="Cart" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="bg-stone-50 min-h-screen py-16">
        <div class="container mx-auto px-4">
            <div class="mb-12 border-b border-stone-200 pb-6">
                <h1 class="font-heritage text-4xl text-amber-900 uppercase tracking-widest">Your Basket</h1>
                <p class="font-serif-italic text-stone-500 mt-2 text-sm">Review your selected Himalayan masterpieces</p>
            </div>

            <asp:Panel ID="pnlCartItems" runat="server">
                <div class="grid grid-cols-1 lg:grid-cols-3 gap-12">
                    
                    <div class="lg:col-span-2">
                        <div class="bg-white border border-stone-200 shadow-sm overflow-hidden">
                            <asp:Repeater ID="rptCartItems" runat="server">
                                <HeaderTemplate>
                                    <div class="hidden md:grid grid-cols-6 bg-stone-100 p-4 text-[10px] font-bold uppercase tracking-widest text-stone-600">
                                        <div class="col-span-3">Product</div>
                                        <div class="text-center">Quantity</div>
                                        <div class="text-right">Subtotal</div>
                                        <div class="text-right">Action</div>
                                    </div>
                                </HeaderTemplate>
                                <ItemTemplate>
                                    <div class="flex flex-col md:grid md:grid-cols-6 items-center border-b border-stone-100 p-6 last:border-b-0 hover:bg-stone-50 transition-colors">
                                        <div class="col-span-3 flex items-center w-full mb-4 md:mb-0">
                                            <div class="w-20 h-24 flex-shrink-0 border border-stone-100 overflow-hidden">
                                                <img src='<%# ResolveUrl(Eval("ImageUrl").ToString()) %>' 
                                                     alt='<%# Eval("ProductName") %>' 
                                                     class="w-full h-full object-cover"
                                                     onerror="this.src='https://via.placeholder.com/200x250?text=KalaSmriti'" />
                                            </div>
                                            <div class="ml-6">
                                                <h3 class="font-heritage text-sm font-bold text-amber-900 uppercase tracking-tighter">
                                                    <a href='ProductDetails.aspx?id=<%# Eval("ProductID") %>' class="hover:text-amber-700">
                                                        <%# Eval("ProductName") %>
                                                    </a>
                                                </h3>
                                                <p class="text-[11px] text-stone-400 mt-1 uppercase tracking-widest">Artisan Crafted</p>
                                                <p class="text-stone-800 font-bold mt-2 text-xs">Rs. <%# String.Format("{0:N0}", Eval("UnitPrice")) %></p>
                                            </div>
                                        </div>

                                        <div class="flex items-center justify-center space-x-4 mb-4 md:mb-0">
                                            <asp:LinkButton ID="btnDecrease" runat="server" CommandName="UpdateQuantity" CommandArgument='<%# Eval("CartID") + ",-1" %>'
                                                OnCommand="UpdateQuantity_Command" CssClass="text-stone-400 hover:text-amber-900 transition"><i class="fas fa-minus text-[10px]"></i></asp:LinkButton>
                                            
                                            <span class="w-8 text-center text-xs font-bold font-heritage"><%# Eval("Quantity") %></span>
                                            
                                            <asp:LinkButton ID="btnIncrease" runat="server" CommandName="UpdateQuantity" CommandArgument='<%# Eval("CartID") + ",1" %>'
                                                OnCommand="UpdateQuantity_Command" CssClass="text-stone-400 hover:text-amber-900 transition"><i class="fas fa-plus text-[10px]"></i></asp:LinkButton>
                                        </div>

                                        <div class="text-center md:text-right font-bold text-amber-900 text-sm mb-4 md:mb-0">
                                            Rs. <%# String.Format("{0:N0}", Convert.ToDecimal(Eval("UnitPrice")) * Convert.ToInt32(Eval("Quantity"))) %>
                                        </div>

                                        <div class="text-right flex justify-end w-full md:w-auto">
                                            <asp:LinkButton ID="btnRemove" runat="server" CommandName="Remove" CommandArgument='<%# Eval("CartID") %>'
                                                OnCommand="RemoveItem_Command" OnClientClick="return confirm('Remove this piece from your collection?');"
                                                CssClass="text-stone-300 hover:text-red-800 transition text-sm">
                                                <i class="fas fa-times"></i>
                                            </asp:LinkButton>
                                        </div>
                                    </div>
                                </ItemTemplate>
                            </asp:Repeater>
                        </div>
                    </div>

                    <div class="lg:col-span-1">
                        <div class="bg-white border border-stone-200 p-8 sticky top-24 shadow-sm">
                            <h2 class="font-heritage text-xl text-amber-900 uppercase tracking-widest mb-8 border-b border-stone-100 pb-4">Summary</h2>
                            
                            <div class="space-y-4 mb-8">
                                <div class="flex justify-between text-xs uppercase tracking-widest text-stone-500">
                                    <span>Subtotal</span>
                                    <span class="font-bold text-stone-800">Rs. <asp:Label ID="lblSubtotal" runat="server"></asp:Label></span>
                                </div>
                                <div class="flex justify-between text-xs uppercase tracking-widest text-stone-500">
                                    <span>Shipping Estimate</span>
                                    <span class="font-bold text-stone-800">Rs. <asp:Label ID="lblShipping" runat="server"></asp:Label></span>
                                </div>
                                <div class="border-t border-stone-100 pt-6 flex justify-between items-baseline">
                                    <span class="font-heritage text-sm uppercase tracking-widest text-amber-900 font-bold">Total</span>
                                    <span class="text-xl font-bold text-amber-800 tracking-tighter">Rs. <asp:Label ID="lblTotal" runat="server"></asp:Label></span>
                                </div>
                            </div>
                            
                            <asp:Button ID="btnCheckout" runat="server" Text="Proceed to Checkout" OnClick="Checkout_Click"
                                CssClass="w-full bg-amber-900 text-white py-5 text-[10px] font-bold uppercase tracking-[0.3em] hover:bg-amber-800 transition-all shadow-lg mb-4 cursor-pointer" />
                            
                            <a href="Shop.aspx" class="block text-center text-[9px] font-bold uppercase tracking-[0.2em] text-stone-400 hover:text-amber-800 transition">
                                <i class="fas fa-chevron-left mr-2"></i> Continue Exploring
                            </a>
                        </div>
                    </div>
                </div>
            </asp:Panel>

            <asp:Panel ID="pnlEmptyCart" runat="server" Visible="false">
                <div class="text-center py-32 bg-white border border-stone-200 shadow-sm">
                    <i class="fas fa-scroll text-stone-100 text-7xl mb-6"></i>
                    <h3 class="font-heritage text-2xl text-amber-900 uppercase tracking-widest mb-2">Your Basket is Empty</h3>
                    <p class="font-serif-italic text-stone-400 mb-10">The start of a thousand-mile journey begins with a single piece of art.</p>
                    <a href="Shop.aspx" class="inline-block bg-amber-900 text-white px-12 py-4 text-[10px] font-bold uppercase tracking-[0.3em] hover:bg-amber-800 transition shadow-xl">
                        Browse the Gallery
                    </a>
                </div>
            </asp:Panel>

            <asp:Panel ID="pnlPurchaseHistory" runat="server" Visible="false" CssClass="mt-16">
                <div class="bg-white border border-stone-200 p-8 shadow-sm">
                    <div class="flex items-center justify-between mb-8 border-b border-stone-100 pb-4">
                        <h2 class="font-heritage text-xl text-amber-900 uppercase tracking-widest">Order History</h2>
                        <a href="Orders.aspx" class="text-[10px] font-bold uppercase tracking-widest text-amber-700 hover:text-amber-900">View All Archive</a>
                    </div>

                    <asp:Repeater ID="rptPurchaseHistory" runat="server">
                        <ItemTemplate>
                            <div class="flex items-center justify-between py-4 border-b border-stone-50 last:border-b-0 hover:bg-stone-50 px-4 transition">
                                <div>
                                    <p class="text-xs font-bold text-amber-900 uppercase tracking-widest">Order #<%# Eval("OrderID") %></p>
                                    <p class="text-[10px] text-stone-400 uppercase mt-1"><%# String.Format("{0:MMM dd, yyyy}", Eval("OrderDate")) %></p>
                                </div>
                                <div class="text-right">
                                    <p class="text-sm font-bold text-stone-800 tracking-tighter">Rs. <%# String.Format("{0:N0}", Eval("TotalAmount")) %></p>
                                    <p class="text-[9px] uppercase tracking-widest text-amber-600 font-bold mt-1"><%# Eval("OrderStatus") %></p>
                                </div>
                            </div>
                        </ItemTemplate>
                    </asp:Repeater>
                </div>
            </asp:Panel>
        </div>
    </div>
</asp:Content>