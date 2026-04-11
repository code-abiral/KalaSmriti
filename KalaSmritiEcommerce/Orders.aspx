<%@ Page Title="My Orders" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeFile="Orders.aspx.cs" Inherits="Orders" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <section class="bg-stone-50 min-h-screen py-14 md:py-20">
        <div class="container mx-auto px-4">
            <div class="max-w-5xl mx-auto">
                <div class="text-center mb-12 md:mb-14">
                    <p class="text-[10px] font-bold uppercase tracking-[0.4em] text-amber-700 mb-3">Purchase Timeline</p>
                    <h1 class="font-heritage text-3xl md:text-4xl text-stone-900 uppercase tracking-[0.08em]">My Orders</h1>
                    <p class="font-serif-italic text-stone-500 text-sm mt-3">Track each handcrafted piece from placement to delivery.</p>
                </div>

                <asp:Panel ID="pnlOrdersContent" runat="server" Visible="false" CssClass="bg-white border border-stone-200 shadow-sm">
                    <div class="px-6 md:px-8 py-5 border-b border-stone-100">
                        <p class="text-[10px] font-bold uppercase tracking-[0.3em] text-stone-400">Order History</p>
                    </div>

                    <div class="hidden md:block overflow-x-auto">
                        <asp:GridView ID="gvOrders" runat="server" AutoGenerateColumns="false" CssClass="w-full min-w-[780px] table-fixed" GridLines="None">
                            <Columns>
                                <asp:BoundField DataField="OrderID" HeaderText="Order" HeaderStyle-CssClass="px-6 py-4 w-[90px]" ItemStyle-CssClass="px-6 py-5 text-sm text-stone-700 font-semibold" />
                                <asp:BoundField DataField="OrderDate" HeaderText="Date" DataFormatString="{0:dd MMM yyyy}" HeaderStyle-CssClass="px-6 py-4 w-[170px]" ItemStyle-CssClass="px-6 py-5 text-sm text-stone-600" />
                                <asp:BoundField DataField="TotalAmount" HeaderText="Amount" DataFormatString="Rs. {0:N2}" HeaderStyle-CssClass="px-6 py-4 w-[190px]" ItemStyle-CssClass="px-6 py-5 text-sm text-amber-900 font-bold" />
                                <asp:TemplateField HeaderText="Order Status" HeaderStyle-CssClass="px-6 py-4 w-[190px]" ItemStyle-CssClass="px-6 py-5">
                                    <ItemTemplate>
                                        <span class='<%# GetOrderStatusCss(Eval("OrderStatus")) %>'><%# Eval("OrderStatus") %></span>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Payment" HeaderStyle-CssClass="px-6 py-4 w-[160px]" ItemStyle-CssClass="px-6 py-5">
                                    <ItemTemplate>
                                        <span class='<%# GetPaymentStatusCss(Eval("PaymentStatus")) %>'><%# Eval("PaymentStatus") %></span>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Feedback" HeaderStyle-CssClass="px-6 py-4 w-[180px]" ItemStyle-CssClass="px-6 py-5 whitespace-nowrap">
                                    <ItemTemplate>
                                        <asp:HyperLink ID="lnkFeedback" runat="server"
                                            NavigateUrl='<%# "~/Feedback.aspx?orderId=" + Eval("OrderID") %>'
                                            CssClass="text-[10px] font-bold uppercase tracking-[0.2em] text-amber-800 hover:text-stone-900"
                                            Visible='<%# Eval("OrderStatus").ToString().ToLower() == "delivered" %>'>Rate</asp:HyperLink>
                                        <asp:Label ID="lblNotEligible" runat="server"
                                            Text="After delivery"
                                            CssClass="text-[10px] uppercase tracking-widest text-stone-400"
                                            Visible='<%# Eval("OrderStatus").ToString().ToLower() != "delivered" %>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                            </Columns>
                            <HeaderStyle CssClass="bg-stone-50 border-y border-stone-100 text-[10px] uppercase tracking-[0.2em] text-stone-500 font-bold text-left" />
                            <RowStyle CssClass="border-b border-stone-100" />
                        </asp:GridView>
                    </div>

                    <div class="md:hidden p-4 space-y-4">
                        <asp:Repeater ID="rptOrdersMobile" runat="server">
                            <ItemTemplate>
                                <div class="border border-stone-200 bg-white p-4">
                                    <div class="flex items-start justify-between gap-3 mb-3">
                                        <div>
                                            <p class="text-[9px] uppercase tracking-[0.3em] text-stone-400 font-bold">Order</p>
                                            <p class="font-heritage text-lg text-stone-800">#<%# Eval("OrderID") %></p>
                                        </div>
                                        <p class="text-amber-900 text-sm font-bold">Rs. <%# String.Format("{0:N2}", Eval("TotalAmount")) %></p>
                                    </div>

                                    <div class="space-y-2 text-[11px] text-stone-600 border-t border-stone-100 pt-3">
                                        <p><span class="uppercase tracking-widest text-stone-400 text-[9px] font-bold mr-2">Date</span><%# String.Format("{0:dd MMM yyyy}", Eval("OrderDate")) %></p>
                                        <p><span class="uppercase tracking-widest text-stone-400 text-[9px] font-bold mr-2">Order</span><span class='<%# GetOrderStatusCss(Eval("OrderStatus")) %>'><%# Eval("OrderStatus") %></span></p>
                                        <p><span class="uppercase tracking-widest text-stone-400 text-[9px] font-bold mr-2">Payment</span><span class='<%# GetPaymentStatusCss(Eval("PaymentStatus")) %>'><%# Eval("PaymentStatus") %></span></p>
                                    </div>

                                    <div class="mt-4 pt-3 border-t border-stone-100">
                                        <asp:HyperLink ID="lnkFeedbackMobile" runat="server"
                                            NavigateUrl='<%# "~/Feedback.aspx?orderId=" + Eval("OrderID") %>'
                                            CssClass="inline-block text-[10px] font-bold uppercase tracking-[0.2em] text-amber-800 hover:text-stone-900"
                                            Visible='<%# Eval("OrderStatus").ToString().ToLower() == "delivered" %>'>Rate Order</asp:HyperLink>
                                        <asp:Label ID="lblNotEligibleMobile" runat="server"
                                            Text="Feedback available after delivery"
                                            CssClass="text-[10px] uppercase tracking-widest text-stone-400"
                                            Visible='<%# Eval("OrderStatus").ToString().ToLower() != "delivered" %>'></asp:Label>
                                    </div>
                                </div>
                            </ItemTemplate>
                        </asp:Repeater>
                    </div>
                </asp:Panel>

                <asp:Panel ID="pnlNoOrders" runat="server" Visible="false" CssClass="bg-white border border-stone-200 shadow-sm p-10 md:p-14 text-center">
                    <i class="fas fa-scroll text-4xl text-amber-200 mb-5"></i>
                    <h2 class="font-heritage text-2xl text-stone-800 uppercase tracking-wide mb-2">No Orders Yet</h2>
                    <p class="font-serif-italic text-stone-500 text-sm mb-8">Your collection journey has not started yet.</p>
                    <a href="Shop.aspx" class="inline-block border border-amber-900 text-amber-900 px-8 py-3 text-[10px] font-bold uppercase tracking-[0.25em] hover:bg-amber-900 hover:text-white transition-colors">Explore Shop</a>
                </asp:Panel>
            </div>
        </div>
    </section>
</asp:Content>
