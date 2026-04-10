<%@ Page Title="Checkout" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeFile="Checkout.aspx.cs" Inherits="Checkout" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="bg-[#1a140f] py-16">
        <div class="container mx-auto px-4 text-center">
            <span class="text-amber-500 font-bold uppercase tracking-[0.4em] text-[10px] mb-2 block">Secure Procurement</span>
            <h1 class="font-heritage text-4xl text-white uppercase tracking-tighter">Checkout</h1>
        </div>
    </div>

    <div class="bg-stone-50 min-h-screen py-12">
        <div class="container mx-auto px-4 max-w-5xl">
            
            <asp:Panel ID="pnlMessage" runat="server" Visible="false" CssClass="mb-8 p-4 border border-amber-200 bg-amber-50 text-amber-900 text-sm font-serif-italic rounded-sm">
                <asp:Label ID="lblMessage" runat="server"></asp:Label>
            </asp:Panel>

            <div class="grid grid-cols-1 lg:grid-cols-12 gap-12">
                
                <div class="lg:col-span-7 space-y-8">
                    <div class="bg-white border border-stone-200 p-8 shadow-sm">
                        <h2 class="font-heritage text-xl text-amber-900 mb-8 uppercase tracking-widest border-b border-stone-100 pb-4">Shipping Destination</h2>
                        <div class="grid grid-cols-1 md:grid-cols-2 gap-x-8 gap-y-6">
                            <div class="md:col-span-2">
                                <label class="block text-[10px] font-bold uppercase tracking-widest text-stone-400 mb-1">Street Address</label>
                                <asp:TextBox ID="txtAddress" runat="server" CssClass="w-full px-0 py-2 border-b border-stone-200 focus:outline-none focus:border-amber-700 transition-colors italic text-sm text-stone-800 bg-transparent" placeholder="e.g. 44600 Thamel Marg"></asp:TextBox>
                            </div>
                            <div>
                                <label class="block text-[10px] font-bold uppercase tracking-widest text-stone-400 mb-1">City</label>
                                <asp:TextBox ID="txtCity" runat="server" CssClass="w-full px-0 py-2 border-b border-stone-200 focus:outline-none focus:border-amber-700 transition-colors italic text-sm text-stone-800 bg-transparent" placeholder="Kathmandu"></asp:TextBox>
                            </div>
                            <div>
                                <label class="block text-[10px] font-bold uppercase tracking-widest text-stone-400 mb-1">State / Province</label>
                                <asp:TextBox ID="txtState" runat="server" CssClass="w-full px-0 py-2 border-b border-stone-200 focus:outline-none focus:border-amber-700 transition-colors italic text-sm text-stone-800 bg-transparent" placeholder="Bagmati"></asp:TextBox>
                            </div>
                            <div>
                                <label class="block text-[10px] font-bold uppercase tracking-widest text-stone-400 mb-1">Zip Code</label>
                                <asp:TextBox ID="txtZip" runat="server" CssClass="w-full px-0 py-2 border-b border-stone-200 focus:outline-none focus:border-amber-700 transition-colors italic text-sm text-stone-800 bg-transparent" placeholder="44600"></asp:TextBox>
                            </div>
                            <div>
                                <label class="block text-[10px] font-bold uppercase tracking-widest text-stone-400 mb-1">Country</label>
                                <asp:TextBox ID="txtCountry" runat="server" CssClass="w-full px-0 py-2 border-b border-stone-200 focus:outline-none focus:border-amber-700 transition-colors italic text-sm text-stone-800 bg-transparent" Text="Nepal"></asp:TextBox>
                            </div>
                        </div>
                    </div>

                    <div class="bg-white border border-stone-200 p-8 shadow-sm">
                        <h2 class="font-heritage text-xl text-amber-900 mb-6 uppercase tracking-widest">Payment Method</h2>
                        <asp:RadioButtonList ID="rblPaymentMethod" runat="server" RepeatDirection="Vertical" AutoPostBack="true" 
                            OnSelectedIndexChanged="rblPaymentMethod_SelectedIndexChanged" 
                            CssClass="heritage-radio-list w-full text-stone-700 text-sm italic">
                            <asp:ListItem Value="COD" Text="&nbsp; Cash on Delivery (Handover)" Selected="True"></asp:ListItem>
                            <asp:ListItem Value="ESEWA" Text="&nbsp; Digital Wallet (eSewa Secure)"></asp:ListItem>
                        </asp:RadioButtonList>

                        <asp:Panel ID="pnlEsewaInfo" runat="server" Visible="false" CssClass="mt-6 p-5 bg-stone-50 border-l-2 border-green-600">
                            <h3 class="text-[11px] font-bold uppercase tracking-widest text-green-800 mb-1">eSewa Secure Redirection</h3>
                            <p class="text-xs text-stone-500 leading-relaxed italic">
                                You will be safely transitioned to the eSewa portal to complete your transaction. Your heritage order will be confirmed immediately after.
                            </p>
                        </asp:Panel>
                    </div>
                </div>

                <div class="lg:col-span-5">
                    <div class="bg-white border border-stone-200 p-8 shadow-sm sticky top-8">
                        <h2 class="font-heritage text-xl text-amber-900 mb-6 uppercase tracking-widest border-b border-stone-100 pb-4">Your Selection</h2>
                        
                        <div class="max-h-64 overflow-y-auto mb-6 pr-2 custom-scrollbar">
                            <asp:Repeater ID="rptItems" runat="server">
                                <ItemTemplate>
                                    <div class="flex justify-between items-center py-3 border-b border-stone-50 last:border-0">
                                        <div class="flex flex-col">
                                            <span class="text-stone-800 text-sm font-medium uppercase tracking-tight"><%# Eval("ProductName") %></span>
                                            <span class="text-stone-400 text-[10px] italic">Quantity: <%# Eval("Quantity") %></span>
                                        </div>
                                        <span class="text-stone-700 text-sm font-heritage">Rs. <%# String.Format("{0:N2}", Eval("LineTotal")) %></span>
                                    </div>
                                </ItemTemplate>
                            </asp:Repeater>
                        </div>

                        <div class="space-y-3 pt-4 border-t border-stone-200">
                            <div class="flex justify-between text-stone-500 text-xs italic">
                                <span>Subtotal</span>
                                <span>Rs. <asp:Label ID="lblSubtotal" runat="server" /></span>
                            </div>
                            <div class="flex justify-between text-stone-500 text-xs italic">
                                <span>Shipping & Handling</span>
                                <span><asp:Label ID="lblShipping" runat="server" /></span>
                            </div>
                            <div class="flex justify-between text-amber-900 font-heritage text-xl pt-4 border-t border-stone-100">
                                <span class="uppercase tracking-widest">Total</span>
                                <span>Rs. <asp:Label ID="lblTotal" runat="server" /></span>
                            </div>
                        </div>

                        <div class="mt-8 space-y-4">
                            <asp:Button ID="btnPlaceOrder" runat="server" Text="Complete Purchase" OnClick="btnPlaceOrder_Click"
                                CssClass="w-full bg-amber-900 text-white py-4 text-[11px] font-bold uppercase tracking-[0.3em] hover:bg-amber-800 transition shadow-lg cursor-pointer" />
                            
                            <a href="Cart.aspx" class="block text-center text-[10px] font-bold uppercase tracking-widest text-stone-400 hover:text-amber-700 transition">
                                <i class="fas fa-arrow-left mr-2 text-[8px]"></i> Modify Cart
                            </a>
                        </div>

                        <div class="mt-8 pt-8 border-t border-stone-100 flex justify-center gap-6 opacity-40 grayscale">
                            <i class="fas fa-shield-alt text-2xl" title="Secure SSL"></i>
                            <i class="fas fa-truck text-2xl" title="Insured Shipping"></i>
                            <i class="fas fa-certificate text-2xl" title="Authentic Art"></i>
                        </div>
                    </div>
                </div>

            </div>
        </div>
    </div>
</asp:Content>