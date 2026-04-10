<%@ Page Title="Manage Orders" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeFile="ManageOrders.aspx.cs" Inherits="Admin_ManageOrders" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="bg-gray-50 min-h-screen py-8">
        <div class="container mx-auto px-4">
            <div class="flex items-center justify-between mb-6">
                <h1 class="text-3xl font-bold text-gray-800">Manage Orders</h1>
                <a href="Dashboard.aspx" class="bg-gray-200 text-gray-700 px-4 py-2 rounded-lg hover:bg-gray-300 transition">Back to Dashboard</a>
            </div>

            <div class="bg-white rounded-lg shadow-md p-6">
                <asp:Panel ID="pnlMessage" runat="server" Visible="false" CssClass="mb-4 p-3 rounded-lg">
                    <asp:Label ID="lblMessage" runat="server"></asp:Label>
                </asp:Panel>

                <asp:GridView ID="gvOrders" runat="server" AutoGenerateColumns="false" CssClass="w-full" GridLines="None" DataKeyNames="OrderID" OnRowCommand="gvOrders_RowCommand" OnRowDataBound="gvOrders_RowDataBound">
                    <Columns>
                        <asp:BoundField DataField="OrderID" HeaderText="Order #" />
                        <asp:BoundField DataField="CustomerName" HeaderText="Customer" />
                        <asp:BoundField DataField="OrderDate" HeaderText="Date" DataFormatString="{0:yyyy-MM-dd}" />
                        <asp:BoundField DataField="TotalAmount" HeaderText="Amount" DataFormatString="Rs. {0:N2}" />
                        <asp:TemplateField HeaderText="Order Status">
                            <ItemTemplate>
                                <asp:DropDownList ID="ddlOrderStatus" runat="server" CssClass="px-2 py-1 border border-gray-300 rounded">
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
                                <asp:DropDownList ID="ddlPaymentStatus" runat="server" CssClass="px-2 py-1 border border-gray-300 rounded">
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
                                <asp:LinkButton ID="btnUpdate" runat="server" CommandName="UpdateOrder" CommandArgument='<%# Container.DataItemIndex %>' CssClass="text-blue-600 hover:text-blue-800">Update</asp:LinkButton>
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
