<%@ Page Title="Register" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeFile="Register.aspx.cs" Inherits="Register" %>

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
            box-shadow: none !important;
        }
        .btn-heritage {
            border-radius: 0px !important;
            letter-spacing: 0.3em;
            text-transform: uppercase;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="min-h-screen flex items-center justify-center py-20 px-4 bg-stone-50">
        <div class="max-w-3xl w-full bg-white p-12 border border-stone-200 shadow-sm">
            
            <div class="text-center mb-12 border-b border-stone-100 pb-8">
                <h2 class="text-4xl font-heritage font-bold text-stone-900 tracking-tight italic">
                    Join the Collective
                </h2>
                <p class="mt-3 text-[10px] uppercase tracking-[0.4em] text-amber-800 font-bold">
                    Create your registry for Himalayan Heritage
                </p>
            </div>

            <asp:Panel ID="pnlError" runat="server" Visible="false" CssClass="mb-6 p-4 bg-red-50 border-l-2 border-red-800 text-[11px] font-bold uppercase tracking-widest text-red-800">
                <asp:Label ID="lblError" runat="server"></asp:Label>
            </asp:Panel>

            <asp:Panel ID="pnlSuccess" runat="server" Visible="false" CssClass="mb-6 p-4 bg-stone-100 border-l-2 border-stone-800 text-[11px] font-bold uppercase tracking-widest text-stone-800">
                <asp:Label ID="lblSuccess" runat="server"></asp:Label>
            </asp:Panel>

            <div class="grid grid-cols-1 md:grid-cols-2 gap-x-8 gap-y-6">
                
                <div class="md:col-span-2 flex flex-col items-center justify-center space-y-4 mb-6 py-6 border-b border-stone-50">
                    <div class="relative group">
                        <div class="w-24 h-24 rounded-full bg-stone-100 border border-stone-200 flex items-center justify-center overflow-hidden">
                            <i class="fas fa-user text-stone-300 text-3xl" id="imgPlaceholder"></i>
                        </div>
                    </div>
                    <div class="text-center">
                        <label class="block text-[9px] font-bold uppercase text-stone-400 mb-2 tracking-widest">Profile Portrait</label>
                        <asp:FileUpload ID="fuProfileImage" runat="server" CssClass="text-[10px] text-stone-500 italic block w-full" />
                    </div>
                </div>

                <div>
                    <label class="block text-[9px] font-bold uppercase text-stone-400 mb-2 tracking-widest">First Name <span class="text-amber-800">*</span></label>
                    <asp:TextBox ID="txtFirstName" runat="server" CssClass="input-heritage w-full px-4 py-3 text-sm italic" placeholder="Enter first name" MaxLength="50" />
                    <asp:RequiredFieldValidator ID="rfvFirstName" runat="server" ControlToValidate="txtFirstName" ErrorMessage="Required" CssClass="text-red-800 text-[10px] italic mt-1" Display="Dynamic" />
                </div>

                <div>
                    <label class="block text-[9px] font-bold uppercase text-stone-400 mb-2 tracking-widest">Last Name <span class="text-amber-800">*</span></label>
                    <asp:TextBox ID="txtLastName" runat="server" CssClass="input-heritage w-full px-4 py-3 text-sm italic" placeholder="Enter last name" MaxLength="50" />
                    <asp:RequiredFieldValidator ID="rfvLastName" runat="server" ControlToValidate="txtLastName" ErrorMessage="Required" CssClass="text-red-800 text-[10px] italic mt-1" Display="Dynamic" />
                </div>

                <div class="md:col-span-1">
                    <label class="block text-[9px] font-bold uppercase text-stone-400 mb-2 tracking-widest">Email Address <span class="text-amber-800">*</span></label>
                    <asp:TextBox ID="txtEmail" runat="server" TextMode="Email" CssClass="input-heritage w-full px-4 py-3 text-sm italic" placeholder="email@example.com" MaxLength="100" />
                    <asp:RequiredFieldValidator ID="rfvEmail" runat="server" ControlToValidate="txtEmail" ErrorMessage="Email is required" CssClass="text-red-800 text-[10px] italic mt-1" Display="Dynamic" />
                </div>

                <div class="md:col-span-1">
                    <label class="block text-[9px] font-bold uppercase text-stone-400 mb-2 tracking-widest">Contact Number</label>
                    <asp:TextBox ID="txtPhone" runat="server" CssClass="input-heritage w-full px-4 py-3 text-sm italic" placeholder="e.g. 98XXXXXXXX" MaxLength="20" />
                </div>

                <div>
                    <label class="block text-[9px] font-bold uppercase text-stone-400 mb-2 tracking-widest">Password <span class="text-amber-800">*</span></label>
                    <asp:TextBox ID="txtPassword" runat="server" TextMode="Password" CssClass="input-heritage w-full px-4 py-3 text-sm" placeholder="••••••••" />
                    <asp:RequiredFieldValidator ID="rfvPassword" runat="server" ControlToValidate="txtPassword" ErrorMessage="Required" CssClass="text-red-800 text-[10px] italic mt-1" Display="Dynamic" />
                </div>

                <div>
                    <label class="block text-[9px] font-bold uppercase text-stone-400 mb-2 tracking-widest">Confirm <span class="text-amber-800">*</span></label>
                    <asp:TextBox ID="txtConfirmPassword" runat="server" TextMode="Password" CssClass="input-heritage w-full px-4 py-3 text-sm" placeholder="••••••••" />
                    <asp:CompareValidator ID="cvPassword" runat="server" ControlToValidate="txtConfirmPassword" ControlToCompare="txtPassword" ErrorMessage="Mismatch" CssClass="text-red-800 text-[10px] italic mt-1" Display="Dynamic" />
                </div>

                <div class="md:col-span-2 pt-4">
                     <h3 class="text-[10px] font-bold text-amber-800 uppercase tracking-[0.3em] mb-4 border-t border-stone-100 pt-6">Shipping Information</h3>
                </div>

                <div class="md:col-span-2">
                    <label class="block text-[9px] font-bold uppercase text-stone-400 mb-2 tracking-widest">Street Address</label>
                    <asp:TextBox ID="txtAddress" runat="server" CssClass="input-heritage w-full px-4 py-3 text-sm italic" placeholder="Enter street address" MaxLength="255" />
                </div>

                <div>
                    <label class="block text-[9px] font-bold uppercase text-stone-400 mb-2 tracking-widest">City</label>
                    <asp:TextBox ID="txtCity" runat="server" CssClass="input-heritage w-full px-4 py-3 text-sm italic" placeholder="City" MaxLength="50" />
                </div>

                <div>
                    <label class="block text-[9px] font-bold uppercase text-stone-400 mb-2 tracking-widest">State/Province</label>
                    <asp:TextBox ID="txtState" runat="server" CssClass="input-heritage w-full px-4 py-3 text-sm italic" placeholder="State" MaxLength="50" />
                </div>

                <div>
                    <label class="block text-[9px] font-bold uppercase text-stone-400 mb-2 tracking-widest">Postal Code</label>
                    <asp:TextBox ID="txtZipCode" runat="server" CssClass="input-heritage w-full px-4 py-3 text-sm italic" placeholder="Zip" MaxLength="10" />
                </div>

                <div>
                    <label class="block text-[9px] font-bold uppercase text-stone-400 mb-2 tracking-widest">Country</label>
                    <asp:TextBox ID="txtCountry" runat="server" Text="Nepal" CssClass="input-heritage w-full px-4 py-3 text-sm italic" MaxLength="50" />
                </div>
            </div>

            <div class="mt-10 p-4 bg-stone-50 border border-stone-100">
                <div class="flex items-start">
                    <asp:CheckBox ID="chkTerms" runat="server" CssClass="mt-1 h-4 w-4 border-stone-300 rounded-none" />
                    <label for="chkTerms" class="ml-3 text-[10px] text-stone-600 uppercase tracking-widest leading-relaxed">
                        I agree to the <a href="#" class="text-amber-800 underline">Terms</a> & <a href="#" class="text-amber-800 underline">Privacy Policy</a>
                    </label>
                </div>
                <asp:CustomValidator ID="cvTerms" runat="server" ErrorMessage="Agreement required" ClientValidationFunction="validateTerms" CssClass="text-red-800 text-[10px] italic mt-1 block" Display="Dynamic" />
            </div>

            <div class="mt-10">
                <asp:Button ID="btnRegister" runat="server" Text="Create Registry" OnClick="btnRegister_Click"
                    CssClass="btn-heritage w-full py-5 bg-stone-900 text-white text-[11px] font-bold hover:bg-amber-900 transition-all cursor-pointer shadow-lg" />
            </div>

            <div class="text-center mt-8">
                <p class="text-[10px] font-bold uppercase tracking-[0.2em] text-stone-400">
                    Already a member? 
                    <a href="Login.aspx" class="text-amber-800 hover:text-stone-900 ml-2">Sign In</a>
                </p>
            </div>
        </div>
    </div>

    <script type="text/javascript">
        function validateTerms(sender, args) {
            var checkbox = document.getElementById('<%= chkTerms.ClientID %>');
            args.IsValid = checkbox.checked;
        }
    </script>
</asp:Content>