<%@ Page Title="Admin Dashboard" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeFile="Dashboard.aspx.cs" Inherits="Admin_Dashboard" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .admin-card { 
            background: white; 
            border: 1px solid #fef3c7; 
            padding: 1.5rem; 
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1); 
        }
        .admin-card:hover { 
            border-color: #b45309; 
            transform: translateY(-2px); 
            box-shadow: 0 10px 15px -3px rgba(180, 83, 9, 0.05); 
        }
        .stat-icon { 
            display: flex; align-items: center; justify-content: center;
            width: 3.5rem; height: 3.5rem; border-radius: 9999px; 
            background: #fffbeb; color: #78350f; 
        }
        /* Custom Scrollbar for a premium feel */
        ::-webkit-scrollbar { width: 5px; }
        ::-webkit-scrollbar-track { background: #fdfcf7; }
        ::-webkit-scrollbar-thumb { background: #d4ad6a; }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="bg-[#fdfcf7] min-h-screen">
        
        <div class="bg-white border-b border-amber-100 py-6 mb-8">
            <div class="container mx-auto px-4 flex flex-col md:flex-row justify-between items-center gap-4">
                <div>
                    <h1 class="font-heritage text-3xl font-bold text-amber-900 tracking-tighter">ADMIN CONSOLE</h1>
                    <div class="flex items-center gap-2 text-[10px] uppercase tracking-widest text-amber-600 font-bold mt-1">
                        <i class="fas fa-shield-alt"></i>
                        <span>Heritage Management System v2.0</span>
                    </div>
                </div>
                
                <div class="flex items-center gap-4">
                    <div class="text-right mr-4 hidden lg:block">
                        <p class="text-[9px] uppercase tracking-widest text-gray-400">Current Session</p>
                        <p class="text-xs font-bold text-amber-900"><%= DateTime.Now.ToString("f") %></p>
                    </div>
                    <asp:LinkButton ID="btnRefresh" runat="server" CssClass="bg-amber-50 text-amber-800 p-3 rounded-sm hover:bg-amber-900 hover:text-white transition shadow-sm">
                        <i class="fas fa-sync-alt"></i>
                    </asp:LinkButton>
                </div>
            </div>
        </div>

        <div class="container mx-auto px-4 pb-20">
            
            <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6 mb-10">
                <div class="admin-card">
                    <div class="flex items-center justify-between">
                        <div>
                            <p class="text-[10px] uppercase tracking-[0.2em] text-amber-700 font-bold mb-1">Catalog Size</p>
                            <p class="text-3xl font-heritage text-gray-900"><asp:Label ID="lblTotalProducts" runat="server">0</asp:Label></p>
                        </div>
                        <div class="stat-icon"><i class="fas fa-gem"></i></div>
                    </div>
                </div>

                <div class="admin-card">
                    <div class="flex items-center justify-between">
                        <div>
                            <p class="text-[10px] uppercase tracking-[0.2em] text-amber-700 font-bold mb-1">Open Orders</p>
                            <p class="text-3xl font-heritage text-gray-900"><asp:Label ID="lblTotalOrders" runat="server">0</asp:Label></p>
                        </div>
                        <div class="stat-icon"><i class="fas fa-truck-loading"></i></div>
                    </div>
                </div>

                <div class="admin-card">
                    <div class="flex items-center justify-between">
                        <div>
                            <p class="text-[10px] uppercase tracking-[0.2em] text-amber-700 font-bold mb-1">Active Artisans</p>
                            <p class="text-3xl font-heritage text-gray-900"><asp:Label ID="lblTotalUsers" runat="server">0</asp:Label></p>
                        </div>
                        <div class="stat-icon"><i class="fas fa-users"></i></div>
                    </div>
                </div>

                <div class="admin-card border-amber-200 bg-amber-900 text-white group">
                    <div class="flex items-center justify-between">
                        <div>
                            <p class="text-[10px] uppercase tracking-[0.2em] text-amber-200 font-bold mb-1">Gross Revenue</p>
                            <p class="text-2xl font-heritage">Rs. <asp:Label ID="lblTotalRevenue" runat="server">0.00</asp:Label></p>
                        </div>
                        <div class="stat-icon bg-white/10 text-white group-hover:scale-110 transition"><i class="fas fa-coins"></i></div>
                    </div>
                </div>
            </div>

            <div class="bg-white border border-amber-100 rounded-sm p-1 shadow-sm mb-12">
                <div class="grid grid-cols-2 lg:grid-cols-4">
                    <a href="ManageProducts.aspx" class="flex flex-col items-center py-8 hover:bg-amber-50 transition duration-300 border-r border-amber-50">
                        <i class="fas fa-plus-circle text-xl text-amber-800 mb-3"></i>
                        <span class="text-[10px] uppercase tracking-[0.3em] font-black text-gray-700">Stock Assets</span>
                    </a>
                    <a href="ManageOrders.aspx" class="flex flex-col items-center py-8 hover:bg-amber-50 transition duration-300 border-r border-amber-50">
                        <i class="fas fa-receipt text-xl text-amber-800 mb-3"></i>
                        <span class="text-[10px] uppercase tracking-[0.3em] font-black text-gray-700">Order Logs</span>
                    </a>
                    <a href="ManageCategories.aspx" class="flex flex-col items-center py-8 hover:bg-amber-50 transition duration-300 border-r border-amber-50">
                        <i class="fas fa-folder-open text-xl text-amber-800 mb-3"></i>
                        <span class="text-[10px] uppercase tracking-[0.3em] font-black text-gray-700">Collections</span>
                    </a>
                    <a href="ManageUsers.aspx" class="flex flex-col items-center py-8 hover:bg-amber-50 transition duration-300">
                        <i class="fas fa-user-lock text-xl text-amber-800 mb-3"></i>
                        <span class="text-[10px] uppercase tracking-[0.3em] font-black text-gray-700">Access Keys</span>
                    </a>
                </div>
            </div>

            <div class="grid grid-cols-1 lg:grid-cols-2 gap-8">
                
                <div class="bg-white border border-amber-100 rounded-sm overflow-hidden shadow-sm">
                    <div class="p-6 border-b border-amber-50 bg-amber-50/20 flex justify-between items-center">
                        <h2 class="font-heritage text-sm text-amber-900 uppercase tracking-widest font-bold">Recent Transactions</h2>
                        <a href="ManageOrders.aspx" class="text-[9px] uppercase font-bold text-amber-700 hover:underline">View All</a>
                    </div>
                    <div class="p-6">
                        <div class="overflow-x-auto">
                            <asp:GridView ID="gvRecentOrders" runat="server" AutoGenerateColumns="false" CssClass="w-full text-xs" GridLines="None">
                                <Columns>
                                    <asp:BoundField DataField="OrderID" HeaderText="ID" HeaderStyle-CssClass="text-left py-4 text-amber-900 border-b border-amber-100" />
                                    <asp:BoundField DataField="CustomerName" HeaderText="Artisan/Client" HeaderStyle-CssClass="text-left py-4 text-amber-900 border-b border-amber-100" />
                                    <asp:BoundField DataField="TotalAmount" HeaderText="Value" DataFormatString="Rs. {0:N0}" HeaderStyle-CssClass="text-right py-4 text-amber-900 border-b border-amber-100" ItemStyle-CssClass="text-right font-bold" />
                                    <asp:TemplateField HeaderText="Status" HeaderStyle-CssClass="text-right py-4 text-amber-900 border-b border-amber-100" ItemStyle-CssClass="text-right">
                                        <ItemTemplate>
                                            <span class="px-2 py-1 text-[9px] font-bold uppercase border border-amber-200 bg-amber-50 text-amber-800 rounded-sm">
                                                <%# Eval("OrderStatus") %>
                                            </span>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                </Columns>
                                <RowStyle CssClass="border-b border-amber-50 hover:bg-amber-50/10" />
                            </asp:GridView>
                        </div>
                    </div>
                </div>

                <div class="bg-white border border-amber-100 rounded-sm overflow-hidden shadow-sm">
                    <div class="p-6 border-b border-amber-50 bg-red-50/20 flex justify-between items-center">
                        <h2 class="font-heritage text-sm text-red-900 uppercase tracking-widest font-bold">Inventory Alerts</h2>
                        <span class="bg-red-600 text-white text-[9px] px-2 py-1 rounded-full font-bold">Action Required</span>
                    </div>
                    <div class="p-6">
                        <div class="overflow-x-auto">
                            <asp:GridView ID="gvLowStock" runat="server" AutoGenerateColumns="false" CssClass="w-full text-xs" GridLines="None">
                                <Columns>
                                    <asp:BoundField DataField="ProductName" HeaderText="Heritage Piece" HeaderStyle-CssClass="text-left py-4 text-amber-900 border-b border-amber-100" />
                                    <asp:TemplateField HeaderText="Units Remaining" HeaderStyle-CssClass="text-center py-4 text-amber-900 border-b border-amber-100" ItemStyle-CssClass="text-center">
                                        <ItemTemplate>
                                            <span class="font-bold <%# Convert.ToInt32(Eval("StockQuantity")) < 5 ? "text-red-600" : "text-amber-700" %>">
                                                <%# Eval("StockQuantity") %> items
                                            </span>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:BoundField DataField="CategoryName" HeaderText="Category" HeaderStyle-CssClass="text-right py-4 text-amber-900 border-b border-amber-100" ItemStyle-CssClass="text-right text-gray-400" />
                                </Columns>
                                <RowStyle CssClass="border-b border-amber-50 hover:bg-red-50/10" />
                            </asp:GridView>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>