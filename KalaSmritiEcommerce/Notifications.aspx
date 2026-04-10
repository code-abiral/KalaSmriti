<%@ Page Title="Notifications" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeFile="Notifications.aspx.cs" Inherits="Notifications" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .notification-card { transition: transform 0.2s ease, box-shadow 0.2s ease; }
        .notification-card:hover { transform: translateY(-2px); }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="bg-[#fdfcf7] min-h-screen py-12">
        <div class="container mx-auto px-4 max-w-3xl">
            
            <div class="flex flex-col md:flex-row md:items-end justify-between gap-4 mb-10 border-b border-amber-100 pb-6">
                <div>
                    <h1 class="font-heritage text-3xl text-stone-800 tracking-tight">My Notifications</h1>
                    <p class="text-stone-500 text-xs uppercase tracking-[0.2em] mt-2">Stay updated with your heritage collection</p>
                </div>
                <asp:LinkButton ID="btnMarkRead" runat="server" OnClick="btnMarkRead_Click"
                    CssClass="text-[10px] font-bold uppercase tracking-widest text-amber-700 hover:text-amber-900 transition-colors border border-amber-200 px-4 py-2 rounded-sm hover:bg-amber-50">
                    Mark All as Read
                </asp:LinkButton>
            </div>

            <asp:Panel ID="pnlMessage" runat="server" Visible="false" CssClass="mb-6 p-4 rounded-sm text-xs font-bold uppercase tracking-widest shadow-sm">
                <asp:Label ID="lblMessage" runat="server"></asp:Label>
            </asp:Panel>

            <div class="space-y-4">
                <asp:Repeater ID="rptNotifications" runat="server">
                    <ItemTemplate>
                        <div class='notification-card bg-white rounded-sm shadow-sm p-6 border-l-2 <%# Convert.ToBoolean(Eval("IsRead")) ? "border-stone-200 opacity-75" : "border-amber-600 shadow-md" %>'>
                            <div class="flex items-start justify-between gap-6">
                                <div class="flex-1">
                                    <div class="flex items-center gap-3 mb-2">
                                        <h3 class="text-sm font-bold text-stone-800 uppercase tracking-wider">
                                            <%# Eval("Title") %>
                                        </h3>
                                        <%# !Convert.ToBoolean(Eval("IsRead")) ? "<span class='bg-amber-600 text-white text-[8px] px-2 py-0.5 rounded-full font-black uppercase'>New</span>" : "" %>
                                    </div>
                                    <p class="text-stone-600 text-sm leading-relaxed italic font-light">
                                        <%# Eval("Message") %>
                                    </p>
                                </div>
                                <div class="text-right whitespace-nowrap">
                                    <span class="text-[9px] text-stone-400 font-bold uppercase tracking-tighter">
                                        <%# Eval("CreatedDate", "{0:MMM dd, yyyy}") %><br />
                                        <%# Eval("CreatedDate", "{0:HH:mm}") %>
                                    </span>
                                </div>
                            </div>
                        </div>
                    </ItemTemplate>
                </asp:Repeater>
            </div>

            <asp:Panel ID="pnlEmpty" runat="server" Visible="false" CssClass="bg-white border border-dashed border-amber-200 rounded-sm p-16 text-center">
                <i class="fas fa-bell-slash text-amber-100 text-5xl mb-4"></i>
                <p class="text-stone-400 text-[11px] uppercase tracking-[0.3em] font-bold">Your gallery of updates is empty</p>
                <a href="Shop.aspx" class="inline-block mt-6 text-[10px] text-amber-700 font-bold uppercase tracking-widest border-b border-amber-700 pb-1 hover:text-amber-900 hover:border-amber-900 transition-all">Explore Collections</a>
            </asp:Panel>

        </div>
    </div>
</asp:Content>