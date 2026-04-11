<%@ Page Title="Manage Orders" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeFile="ManageOrders.aspx.cs" Inherits="Admin_ManageOrders" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <section class="bg-stone-50 min-h-screen py-14 md:py-20">
        <div class="container mx-auto px-4">
            <div class="max-w-6xl mx-auto space-y-8">
                <div class="flex flex-col md:flex-row md:items-end md:justify-between gap-4">
                    <div>
                        <p class="text-[10px] font-bold uppercase tracking-[0.4em] text-amber-700 mb-3">Admin Console</p>
                        <h1 class="font-heritage text-3xl md:text-4xl text-stone-900 uppercase tracking-[0.08em]">Order Logs</h1>
                        <p class="font-serif-italic text-stone-500 text-sm mt-3">Track fulfillment and payment progress with precision.</p>
                    </div>
                    <a href="Dashboard.aspx" class="inline-block border border-stone-300 text-stone-600 px-5 py-2 text-[10px] font-bold uppercase tracking-[0.2em] hover:border-amber-800 hover:text-amber-900 transition-colors">Back to Dashboard</a>
                </div>

                <div class="bg-white border border-stone-200 shadow-sm p-6 md:p-8">
                    <asp:Panel ID="pnlMessage" runat="server" Visible="false" CssClass="mb-4 p-3 rounded-lg">
                        <asp:Label ID="lblMessage" runat="server"></asp:Label>
                    </asp:Panel>

                    <div class="overflow-x-auto">
                        <asp:GridView ID="gvOrders" runat="server" AutoGenerateColumns="false" CssClass="w-full min-w-[980px]" GridLines="None" DataKeyNames="OrderID" OnRowCommand="gvOrders_RowCommand" OnRowDataBound="gvOrders_RowDataBound">
                    <Columns>
                        <asp:BoundField DataField="OrderID" HeaderText="Order #" />
                        <asp:BoundField DataField="CustomerName" HeaderText="Customer" />
                        <asp:BoundField DataField="OrderDate" HeaderText="Date" DataFormatString="{0:yyyy-MM-dd}" />
                        <asp:BoundField DataField="TotalAmount" HeaderText="Amount" DataFormatString="Rs. {0:N2}" />
                        <asp:TemplateField HeaderText="Order Status">
                            <ItemTemplate>
                                <asp:DropDownList ID="ddlOrderStatus" runat="server" CssClass="px-3 py-2 border border-stone-200 bg-white text-sm text-stone-700 focus:outline-none focus:border-amber-800">
                                    <asp:ListItem Value="Pending" Text="Pending"></asp:ListItem>
                                    <asp:ListItem Value="Confirmed" Text="Confirmed"></asp:ListItem>
                                    <asp:ListItem Value="Out for Delivery" Text="Out for Delivery"></asp:ListItem>
                                    <asp:ListItem Value="Delivered" Text="Delivered"></asp:ListItem>
                                    <asp:ListItem Value="Canceled" Text="Canceled"></asp:ListItem>
                                </asp:DropDownList>
                                <asp:HiddenField ID="hfOrderStatus" runat="server" Value='<%# Eval("OrderStatus") %>' />
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Payment Status">
                            <ItemTemplate>
                                <asp:DropDownList ID="ddlPaymentStatus" runat="server" CssClass="px-3 py-2 border border-stone-200 bg-white text-sm text-stone-700 focus:outline-none focus:border-amber-800">
                                    <asp:ListItem Value="Pending" Text="Pending"></asp:ListItem>
                                    <asp:ListItem Value="Paid" Text="Paid"></asp:ListItem>
                                    <asp:ListItem Value="Failed" Text="Failed"></asp:ListItem>
                                    <asp:ListItem Value="Refunded" Text="Refunded"></asp:ListItem>
                                </asp:DropDownList>
                                <asp:HiddenField ID="hfPaymentStatus" runat="server" Value='<%# Eval("PaymentStatus") %>' />
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Actions">
                            <ItemTemplate>
                                <asp:LinkButton ID="btnUpdate" runat="server" CommandName="UpdateOrder" CommandArgument='<%# Container.DataItemIndex %>' CssClass="inline-block bg-amber-900 text-white px-4 py-2 text-[10px] font-bold uppercase tracking-[0.2em] hover:bg-amber-800 transition">Update</asp:LinkButton>
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
