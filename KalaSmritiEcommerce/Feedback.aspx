<%@ Page Title="Order Feedback" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeFile="Feedback.aspx.cs" Inherits="Feedback" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="bg-[#1a140f] py-16">
        <div class="container mx-auto px-4 text-center">
            <span class="text-amber-500 font-bold uppercase tracking-[0.4em] text-[10px] mb-2 block">Collector's Voice</span>
            <h1 class="font-heritage text-4xl text-white uppercase tracking-tighter">Rate Your Experience</h1>
        </div>
    </div>

    <div class="bg-stone-50 min-h-screen py-12">
        <div class="container mx-auto px-4 max-w-4xl">

            <asp:Panel ID="pnlMessage" runat="server" Visible="false" CssClass="mb-8 p-4 border border-amber-200 bg-amber-50 text-amber-900 text-sm font-serif-italic rounded-sm">
                <asp:Label ID="lblMessage" runat="server"></asp:Label>
            </asp:Panel>

            <asp:Panel ID="pnlFeedbackForm" runat="server" Visible="true" CssClass="space-y-10">
                
                <div class="bg-white border border-stone-200 p-8 md:p-12 shadow-sm">
                    <h2 class="font-heritage text-xl text-amber-900 mb-8 uppercase tracking-widest border-b border-stone-100 pb-4">Artisanal Assessment</h2>

                    <asp:Repeater ID="rptProducts" runat="server">
                        <ItemTemplate>
                            <div class="group border-b border-stone-100 last:border-0 pb-8 mb-8 last:mb-0 last:pb-0">
                                <asp:HiddenField ID="hfProductId" runat="server" Value='<%# Eval("ProductID") %>' />
                                <asp:HiddenField ID="hfExistingRating" runat="server" Value='<%# Eval("ExistingRating") == DBNull.Value ? "" : Eval("ExistingRating").ToString() %>' />
                                <asp:HiddenField ID="hfExistingReview" runat="server" Value='<%# Eval("ExistingReview") == DBNull.Value ? "" : Eval("ExistingReview").ToString() %>' />
                                
                                <div class="flex flex-col md:flex-row md:items-center justify-between gap-4 mb-6">
                                    <div>
                                        <h3 class="text-stone-800 text-sm font-bold uppercase tracking-widest group-hover:text-amber-800 transition-colors"><%# Eval("ProductName") %></h3>
                                        <p class="text-[10px] text-stone-400 font-serif-italic mt-1 uppercase tracking-tighter">Edition Count: <%# Eval("Quantity") %></p>
                                    </div>
                                    <div class="w-full md:w-64">
                                        <label class="block text-[9px] font-bold uppercase tracking-widest text-stone-400 mb-2">Heritage Rating</label>
                                        <asp:DropDownList ID="ddlRating" runat="server" CssClass="w-full bg-stone-50 border border-stone-200 py-2 px-3 text-xs italic text-stone-700 outline-none focus:border-amber-700">
                                            <asp:ListItem Value="">— Select Merit —</asp:ListItem>
                                            <asp:ListItem Value="5">5 - Exceptional Masterpiece</asp:ListItem>
                                            <asp:ListItem Value="4">4 - Exemplary Craft</asp:ListItem>
                                            <asp:ListItem Value="3">3 - Worthy Collection</asp:ListItem>
                                            <asp:ListItem Value="2">2 - Standard Quality</asp:ListItem>
                                            <asp:ListItem Value="1">1 - Needs Attention</asp:ListItem>
                                        </asp:DropDownList>
                                    </div>
                                </div>

                                <div class="relative">
                                    <label class="block text-[9px] font-bold uppercase tracking-widest text-stone-400 mb-2">Observations</label>
                                    <asp:TextBox ID="txtReview" runat="server" TextMode="MultiLine" Rows="2" 
                                        CssClass="w-full px-0 py-2 border-b border-stone-200 focus:outline-none focus:border-amber-700 transition-colors italic text-sm text-stone-800 bg-transparent resize-none" 
                                        placeholder="Describe the craftsmanship and feel..."></asp:TextBox>
                                </div>
                            </div>
                        </ItemTemplate>
                    </asp:Repeater>
                </div>

                <div class="bg-white border border-stone-200 p-8 md:p-12 shadow-sm">
                    <h2 class="font-heritage text-xl text-amber-900 mb-8 uppercase tracking-widest border-b border-stone-100 pb-4">Service & Logistics</h2>
                    
                    <div class="grid grid-cols-1 md:grid-cols-12 gap-8">
                        <div class="md:col-span-4">
                            <label class="block text-[9px] font-bold uppercase tracking-widest text-stone-400 mb-2">Journey Satisfaction</label>
                            <asp:DropDownList ID="ddlTransactionRating" runat="server" CssClass="w-full bg-stone-50 border border-stone-200 py-2 px-3 text-xs italic text-stone-700 outline-none focus:border-amber-700">
                                <asp:ListItem Value="">— Service Merit —</asp:ListItem>
                                <asp:ListItem Value="5">5 - Faultless Delivery</asp:ListItem>
                                <asp:ListItem Value="4">4 - Efficient Service</asp:ListItem>
                                <asp:ListItem Value="3">3 - Satisfactory</asp:ListItem>
                                <asp:ListItem Value="2">2 - Minor Delays</asp:ListItem>
                                <asp:ListItem Value="1">1 - Poor Experience</asp:ListItem>
                            </asp:DropDownList>
                        </div>
                        <div class="md:col-span-8">
                            <label class="block text-[9px] font-bold uppercase tracking-widest text-stone-400 mb-2">Payment & Fulfillment Comments</label>
                            <asp:TextBox ID="txtTransactionComment" runat="server" 
                                CssClass="w-full px-0 py-2 border-b border-stone-200 focus:outline-none focus:border-amber-700 transition-colors italic text-sm text-stone-800 bg-transparent" 
                                placeholder="Share your thoughts on the delivery and checkout process..."></asp:TextBox>
                        </div>
                    </div>
                </div>

                <div class="flex flex-col md:flex-row gap-4 items-center justify-center pt-6">
                    <asp:Button ID="btnSubmitFeedback" runat="server" Text="Submit Testimony" OnClick="btnSubmitFeedback_Click"
                        CssClass="w-full md:w-64 bg-amber-900 text-white py-4 text-[11px] font-bold uppercase tracking-[0.3em] hover:bg-amber-800 transition shadow-lg cursor-pointer" />
                    
                    <a href="Orders.aspx" class="text-[10px] font-bold uppercase tracking-widest text-stone-400 hover:text-amber-700 transition">
                        <i class="fas fa-arrow-left mr-2 text-[8px]"></i> Return to Orders
                    </a>
                </div>
            </asp:Panel>
        </div>
    </div>
</asp:Content>