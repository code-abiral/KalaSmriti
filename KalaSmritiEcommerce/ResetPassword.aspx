<%@ Page Title="Reset Password" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeFile="ResetPassword.aspx.cs" Inherits="ResetPassword" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div class="min-h-screen flex items-center justify-center py-12 px-4 sm:px-6 lg:px-8 bg-stone-50">
        <div class="max-w-md w-full space-y-6 bg-white p-10 border border-stone-200 shadow-sm">
            <div class="text-center">
                <h2 class="font-heritage text-3xl text-stone-900 uppercase tracking-tighter">
                    Reset <span class="italic text-amber-800">Passkey</span>
                </h2>
                <p class="mt-2 font-serif-italic text-sm text-stone-500">
                    Set a new password for your KalaSmriti account
                </p>
            </div>

            <asp:Panel ID="pnlMessage" runat="server" Visible="false" CssClass="p-4 border-l-2 text-[10px] font-bold uppercase tracking-widest">
                <asp:Label ID="lblMessage" runat="server"></asp:Label>
            </asp:Panel>

            <asp:Panel ID="pnlForm" runat="server" CssClass="space-y-4">
                <div>
                    <label class="block text-[10px] font-bold uppercase tracking-[0.2em] text-stone-400 mb-2">New Password</label>
                    <asp:TextBox ID="txtNewPassword" runat="server" TextMode="Password"
                        CssClass="appearance-none rounded-none relative block w-full px-4 py-4 border border-stone-200 placeholder-stone-300 text-stone-900 focus:outline-none focus:border-amber-900 focus:ring-0 text-sm transition-colors italic"
                        placeholder="At least 8 characters" />
                </div>

                <div>
                    <label class="block text-[10px] font-bold uppercase tracking-[0.2em] text-stone-400 mb-2">Confirm Password</label>
                    <asp:TextBox ID="txtConfirmPassword" runat="server" TextMode="Password"
                        CssClass="appearance-none rounded-none relative block w-full px-4 py-4 border border-stone-200 placeholder-stone-300 text-stone-900 focus:outline-none focus:border-amber-900 focus:ring-0 text-sm transition-colors italic"
                        placeholder="Re-enter your new password" />
                </div>

                <asp:Button ID="btnResetPassword" runat="server" Text="Reset Password" OnClick="btnResetPassword_Click"
                    CssClass="w-full py-4 text-[11px] font-bold uppercase tracking-[0.25em] text-white bg-[#1a140f] hover:bg-amber-900 transition-all cursor-pointer" />
            </asp:Panel>

            <div class="text-center text-[10px] font-bold uppercase tracking-widest text-stone-400">
                <a href="Login.aspx" class="text-amber-800 hover:text-stone-900">Back to Login</a>
            </div>
        </div>
    </div>
</asp:Content>
