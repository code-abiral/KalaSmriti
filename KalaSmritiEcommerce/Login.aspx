<%@ Page Title="Login" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeFile="Login.aspx.cs" Inherits="Login" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .btn-heritage-rectangular {
            border-radius: 0px !important;
            -webkit-appearance: none !important;
            appearance: none !important;
            border: none !important;
        }
        .user-placeholder-frame {
            border: 1px solid #e7e5e4; /* stone-200 */
            padding: 8px;
            background: white;
            position: relative;
        }
        /* Styling the file upload to be a discreet overlay */
        .upload-overlay {
            position: absolute;
            bottom: 0;
            right: 0;
            background: #1a140f;
            width: 32px;
            height: 32px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            cursor: pointer;
            border: 2px solid white;
            transition: all 0.3s ease;
        }
        .upload-overlay:hover {
            background: #b45309; /* amber-700 */
            transform: scale(1.1);
        }
        /* Hide the actual file input but keep it functional */
        .hidden-upload {
            display: none;
        }
    </style>
    <script type="text/javascript">
        // Client-side preview of the uploaded image
        function previewImage(input) {
            if (input.files && input.files[0]) {
                var reader = new FileReader();
                reader.onload = function (e) {
                    document.getElementById('<%= imgUserPreview.ClientID %>').src = e.target.result;
                    document.getElementById('<%= imgUserPreview.ClientID %>').style.display = 'block';
                    document.getElementById('defaultUserIcon').style.display = 'none';
                };
                reader.readAsDataURL(input.files[0]);
            }
        }
    </script>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="min-h-screen flex items-center justify-center py-12 px-4 sm:px-6 lg:px-8 bg-stone-50">
        <div class="max-w-md w-full space-y-8 bg-white p-10 border border-stone-200 shadow-sm">
            
            <div class="text-center">
                <!-- <div class="relative inline-block">
                    <div class="user-placeholder-frame rounded-full">
                        <div class="h-28 w-28 rounded-full bg-stone-100 flex items-center justify-center overflow-hidden border border-stone-50">
                            <i id="defaultUserIcon" class="fas fa-user text-stone-300 text-5xl"></i>
                            <asp:Image ID="imgUserPreview" runat="server" CssClass="h-full w-full object-cover" style="display:none;" />
                        </div>
                    </div>
                    
                    <label for="<%= fuProfileImage.ClientID %>" class="upload-overlay shadow-md">
                        <i class="fas fa-camera text-[12px]"></i>
                    </label>
                    <asp:FileUpload ID="fuProfileImage" runat="server" class="hidden-upload" onchange="previewImage(this)" />
                </div> -->
                
                <h2 class="font-heritage text-3xl text-stone-900 uppercase tracking-tighter mt-6">
                    Collector <span class="italic text-amber-800">Access</span>
                </h2>
                <p class="mt-2 font-serif-italic text-sm text-stone-500">
                    Verify identity to manage your collection
                </p>
            </div>

            <div class="mt-8 space-y-6">
                <asp:Panel ID="pnlError" runat="server" Visible="false" CssClass="p-4 bg-red-50 border-l-2 border-red-700 text-red-800 text-[10px] font-bold uppercase tracking-widest">
                    <asp:Label ID="lblError" runat="server"></asp:Label>
                </asp:Panel>

                <asp:Panel ID="pnlInfo" runat="server" Visible="false" CssClass="p-4 bg-emerald-50 border-l-2 border-emerald-700 text-emerald-800 text-[10px] font-bold uppercase tracking-widest">
                    <asp:Label ID="lblInfo" runat="server"></asp:Label>
                </asp:Panel>

                <div class="space-y-5">
                    <div>
                        <label class="block text-[10px] font-bold uppercase tracking-[0.2em] text-stone-400 mb-2">Registry Email</label>
                        <asp:TextBox ID="txtEmail" runat="server" TextMode="Email"
                            CssClass="appearance-none rounded-none relative block w-full px-4 py-4 border border-stone-200 placeholder-stone-300 text-stone-900 focus:outline-none focus:border-amber-900 focus:ring-0 text-sm transition-colors italic"
                            placeholder="email@registry.com" required="required" />
                    </div>

                    <div>
                        <label class="block text-[10px] font-bold uppercase tracking-[0.2em] text-stone-400 mb-2">Passkey</label>
                        <asp:TextBox ID="txtPassword" runat="server" TextMode="Password"
                            CssClass="appearance-none rounded-none relative block w-full px-4 py-4 border border-stone-200 placeholder-stone-300 text-stone-900 focus:outline-none focus:border-amber-900 focus:ring-0 text-sm transition-colors italic"
                            placeholder="••••••••" required="required" />
                    </div>
                </div>

                <div class="flex items-center justify-between">
                    <div class="flex items-center">
                        <asp:CheckBox ID="chkRememberMe" runat="server" CssClass="h-4 w-4 accent-amber-900 border-stone-300 rounded-none" />
                        <label for="chkRememberMe" class="ml-2 block text-[10px] font-bold uppercase tracking-widest text-stone-500">Persist Session</label>
                    </div>
                </div>

                <div class="border border-stone-200 p-4 bg-stone-50">
                    <label class="block text-[10px] font-bold uppercase tracking-[0.2em] text-stone-400 mb-2">Lost Passkey?</label>
                    <div class="flex gap-2">
                        <span class="flex-1 text-[10px] text-stone-500 italic self-center">Uses the Registry Email field above</span>
                        <asp:Button ID="btnForgotPassword" runat="server" Text="Send Reset Link" OnClick="btnForgotPassword_Click" CausesValidation="false" UseSubmitBehavior="false"
                            CssClass="btn-heritage-rectangular px-5 text-[10px] font-bold uppercase tracking-[0.25em] text-white bg-stone-800 hover:bg-amber-900 transition-all cursor-pointer" />
                    </div>
                </div>

                <div>
                    <asp:Button ID="btnLogin" runat="server" Text="Verify & Enter" OnClick="btnLogin_Click"
                        CssClass="btn-heritage-rectangular w-full flex justify-center py-5 px-4 text-[11px] font-bold uppercase tracking-[0.4em] text-white bg-[#1a140f] hover:bg-amber-900 transition-all cursor-pointer shadow-lg" />
                </div>

                <div class="text-center pt-4 border-t border-stone-100">
                    <p class="text-[10px] font-bold uppercase tracking-widest text-stone-400">
                        New to the collection? 
                        <a href="Register.aspx" class="text-amber-800 hover:text-stone-900 ml-1">Register Identity</a>
                    </p>
                </div>
            </div>
        </div>
    </div>
</asp:Content>