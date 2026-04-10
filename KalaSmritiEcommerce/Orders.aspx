<%@ Page Title="My Orders" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeFile="Orders.aspx.cs" Inherits="Orders" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="bg-gray-50 min-h-screen py-8">
        <div class="container mx-auto px-4">
            <h1 class="text-3xl font-bold text-gray-800 mb-6">My Orders</h1>

            <div class="bg-white rounded-lg shadow-md p-6">
                <asp:GridView ID="gvOrders" runat="server" AutoGenerateColumns="false" CssClass="w-full" GridLines="None">
                    <Columns>
                        <asp:BoundField DataField="OrderID" HeaderText="Order #" />
                        <asp:BoundField DataField="OrderDate" HeaderText="Date" DataFormatString="{0:yyyy-MM-dd}" />
                        <asp:BoundField DataField="TotalAmount" HeaderText="Amount" DataFormatString="Rs. {0:N2}" />
                        <asp:BoundField DataField="OrderStatus" HeaderText="Order Status" />
                        <asp:BoundField DataField="PaymentStatus" HeaderText="Payment" />
                        <asp:TemplateField HeaderText="Feedback">
                            <ItemTemplate>
                                <asp:HyperLink ID="lnkFeedback" runat="server" NavigateUrl='<%# "~/Feedback.aspx?orderId=" + Eval("OrderID") %>' CssClass="text-blue-600 hover:text-blue-800" Visible='<%# Eval("OrderStatus").ToString().ToLower() == "delivered" %>'>Rate Order</asp:HyperLink>
                                <asp:Label ID="lblNotEligible" runat="server" Text="Available after delivery" CssClass="text-gray-500 text-sm" Visible='<%# Eval("OrderStatus").ToString().ToLower() != "delivered" %>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                    <HeaderStyle CssClass="bg-gray-100 text-gray-700 font-semibold py-3 px-4 text-left" />
                    <RowStyle CssClass="border-b border-gray-200 py-3 px-4" />
                    <EmptyDataTemplate>
                        <div class="text-center text-gray-600 py-6">No orders found.</div>
                    </EmptyDataTemplate>
                </asp:GridView>
            </div>
        </div>
    </div>
</asp:Content>
