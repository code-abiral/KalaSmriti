<%@ Page Title="My Identity" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeFile="Profile.aspx.cs" Inherits="ProfilePage" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:ital,wght@0,400;0,700;1,400&family=Inter:wght@300;400;600&display=swap" rel="stylesheet">
    <style>
        .font-heritage { font-family: 'Playfair Display', serif; }
        .input-heritage {
            border-radius: 0px !important;
            border: 1px solid #e7e5e4;
            transition: all 0.3s ease;
        }
        .input-heritage:focus {
            border-color: #78350f !important;
            outline: none;
        }
        /* Profile Image Styles */
        .profile-container {
            width: 140px;
            height: 140px;
            border: 1px solid #e7e5e4;
            padding: 4px;
            position: relative;
        }
        .upload-trigger {
            position: absolute;
            bottom: 0;
            right: 0;
            background: #1a140f;
            color: white;
            width: 32px;
            height: 32px;
            display: flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            border: 2px solid #fff;
        }
    </style>
    <script type="text/javascript">
        function previewProfile(input) {
            if (input.files && input.files[0]) {
                var reader = new FileReader();
                reader.onload = function (e) {
                    document.getElementById('<%= imgUserPreview.ClientID %>').src = e.target.result;
                };
                reader.readAsDataURL(input.files[0]);
            }
        }
    </script>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="bg-stone-50 min-h-screen py-16">
        <div class="container mx-auto px-4 max-w-4xl">
            
            <div class="flex flex-col md:flex-row items-center md:items-end justify-between mb-10 border-b border-stone-200 pb-8">
                <div>
                    <h1 class="text-4xl font-heritage font-bold text-stone-900 tracking-tight">Your Identity</h1>
                    <p class="text-stone-500 italic text-sm mt-1">Manage your personal collection registry</p>
                </div>
                
                <div class="mt-6 md:mt-0">
                    <div class="profile-container bg-white">
                        <asp:Image ID="imgUserPreview" runat="server" ImageUrl="~/Images/default-user.png" CssClass="w-full h-full object-cover" />
                        <label for="<%= fuProfileImage.ClientID %>" class="upload-trigger hover:bg-amber-900 transition-colors">
                            <i class="fas fa-camera text-[12px]"></i>
                        </label>
                        <asp:FileUpload ID="fuProfileImage" runat="server" class="hidden" onchange="previewProfile(this)" />
                    </div>
                </div>
            </div>

            <asp:Panel ID="pnlMessage" runat="server" Visible="false" CssClass="mb-8 p-4 bg-stone-100 border-l-2 border-stone-800 text-[10px] font-bold uppercase tracking-[0.2em] text-stone-800">
                <asp:Label ID="lblMessage" runat="server"></asp:Label>
            </asp:Panel>

            <div class="bg-white p-10 border border-stone-200 shadow-sm">
                <div class="grid grid-cols-1 md:grid-cols-2 gap-x-10 gap-y-8">
                    
                    <div class="md:col-span-2">
                        <h3 class="text-[10px] font-bold text-amber-800 uppercase tracking-[0.3em] mb-4">Registry Information</h3>
                    </div>

                    <div>
                        <label class="block text-[9px] font-bold uppercase text-stone-400 mb-2 tracking-widest">First Name</label>
                        <asp:TextBox ID="txtFirstName" runat="server" CssClass="input-heritage w-full px-4 py-3 text-sm italic" placeholder="First name"></asp:TextBox>
                    </div>

                    <div>
                        <label class="block text-[9px] font-bold uppercase text-stone-400 mb-2 tracking-widest">Last Name</label>
                        <asp:TextBox ID="txtLastName" runat="server" CssClass="input-heritage w-full px-4 py-3 text-sm italic" placeholder="Last name"></asp:TextBox>
                    </div>

                    <div class="md:col-span-2">
                        <label class="block text-[9px] font-bold uppercase text-stone-400 mb-2 tracking-widest">Registry Email (Permanent)</label>
                        <asp:TextBox ID="txtEmail" runat="server" CssClass="input-heritage w-full px-4 py-3 text-sm bg-stone-50 text-stone-500" placeholder="Email" ReadOnly="true"></asp:TextBox>
                    </div>

                    <div class="md:col-span-2 mt-4">
                        <h3 class="text-[10px] font-bold text-amber-800 uppercase tracking-[0.3em] mb-4 border-t border-stone-100 pt-8">Residence & Contact</h3>
                    </div>

                    <div>
                        <label class="block text-[9px] font-bold uppercase text-stone-400 mb-2 tracking-widest">Phone Number</label>
                        <asp:TextBox ID="txtPhone" runat="server" CssClass="input-heritage w-full px-4 py-3 text-sm italic" placeholder="Phone"></asp:TextBox>
                    </div>

                    <div>
                        <label class="block text-[9px] font-bold uppercase text-stone-400 mb-2 tracking-widest">City</label>
                        <asp:TextBox ID="txtCity" runat="server" CssClass="input-heritage w-full px-4 py-3 text-sm italic" placeholder="City"></asp:TextBox>
                    </div>

                    <div class="md:col-span-2">
                        <label class="block text-[9px] font-bold uppercase text-stone-400 mb-2 tracking-widest">Street Address</label>
                        <asp:TextBox ID="txtAddress" runat="server" CssClass="input-heritage w-full px-4 py-3 text-sm italic" placeholder="Full address"></asp:TextBox>
                    </div>

                    <div>
                        <label class="block text-[9px] font-bold uppercase text-stone-400 mb-2 tracking-widest">State / Province</label>
                        <asp:TextBox ID="txtState" runat="server" CssClass="input-heritage w-full px-4 py-3 text-sm italic" placeholder="State"></asp:TextBox>
                    </div>

                    <div>
                        <label class="block text-[9px] font-bold uppercase text-stone-400 mb-2 tracking-widest">Postal Code</label>
                        <asp:TextBox ID="txtZip" runat="server" CssClass="input-heritage w-full px-4 py-3 text-sm italic" placeholder="Zip Code"></asp:TextBox>
                    </div>

                    <div class="md:col-span-2">
                        <label class="block text-[9px] font-bold uppercase text-stone-400 mb-2 tracking-widest">Country</label>
                        <asp:TextBox ID="txtCountry" runat="server" CssClass="input-heritage w-full px-4 py-3 text-sm italic" placeholder="Country"></asp:TextBox>
                    </div>
                </div>

                <div class="mt-12 flex justify-end">
                    <asp:Button ID="btnSave" runat="server" Text="Update Registry" OnClick="btnSave_Click"
                        CssClass="bg-stone-900 text-white px-10 py-4 text-[11px] font-bold uppercase tracking-[0.4em] hover:bg-amber-900 transition-all cursor-pointer shadow-lg" />
                </div>
            </div>
        </div>
    </div>
</asp:Content>