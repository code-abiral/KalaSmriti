<%@ Page Title="Home" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeFile="Default.aspx.cs" Inherits="_Default" %>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    
    <section class="relative h-[85vh] flex items-center overflow-hidden">
        <div class="absolute inset-0 z-0">
            <img src="Images/Gemini_Generated_Image_sip19dsip19dsip1.png" 
                 class="w-full h-full object-cover brightness-[0.4] scale-105" 
                 alt="KalaSmriti Heritage Hero" />
        </div>
        
        <div class="container mx-auto px-4 relative z-10 text-center md:text-left">
            <span class="text-amber-400 font-bold uppercase tracking-[0.5em] text-xs mb-4 block">Handmade in the Himalayas</span>
            <h1 class="font-heritage text-5xl md:text-8xl text-white mb-8 leading-tight">
                Art that Echoes <br /> <span class="italic text-amber-200">History</span>
            </h1>
            <div class="flex flex-col md:flex-row gap-5 justify-center md:justify-start">
                <a href="Shop.aspx" class="bg-amber-700 text-white px-10 py-4 text-xs font-bold uppercase tracking-[0.2em] hover:bg-amber-800 transition shadow-2xl">Shop Masterpieces</a>
                <a href="About.aspx" class="bg-white/10 backdrop-blur-md border border-white text-white px-10 py-4 text-xs font-bold uppercase tracking-[0.2em] hover:bg-white hover:text-amber-900 transition">Our Legacy</a>
            </div>
        </div>

        <div class="absolute bottom-0 left-0 w-full h-24 bg-gradient-to-t from-white to-transparent z-10"></div>
    </section>

    <section class="py-24 bg-white relative">
        <div class="container mx-auto px-4">
            <div class="text-center mb-20">
                <h2 class="font-heritage text-3xl md:text-4xl text-amber-900 mb-4 italic">Why Choose KalaSmriti?</h2>
                <div class="w-16 h-[2px] bg-amber-800 mx-auto"></div>
            </div>

            <div class="grid grid-cols-1 md:grid-cols-3 gap-16">
                <div class="text-center group">
                    <div class="mb-6 relative inline-block">
                        <div class="absolute inset-0 bg-amber-100 rounded-full scale-150 opacity-0 group-hover:opacity-100 transition duration-500"></div>
                        <i class="fas fa-award text-4xl text-amber-800 relative z-10"></i>
                    </div>
                    <h4 class="font-heritage text-xl mb-4 text-amber-900 uppercase tracking-widest">100% Authentic</h4>
                    <p class="text-gray-500 text-sm leading-relaxed max-w-xs mx-auto">Directly sourced from the heart of Kathmandu. No middle-man, only original craftsmanship.</p>
                </div>

                <div class="text-center group">
                    <div class="mb-6 relative inline-block">
                        <div class="absolute inset-0 bg-amber-100 rounded-full scale-150 opacity-0 group-hover:opacity-100 transition duration-500"></div>
                        <i class="fas fa-hand-holding-heart text-4xl text-amber-800 relative z-10"></i>
                    </div>
                    <h4 class="font-heritage text-xl mb-4 text-amber-900 uppercase tracking-widest">Artisan First</h4>
                    <p class="text-gray-500 text-sm leading-relaxed max-w-xs mx-auto">Ensuring fair wages and keeping the traditional skills of Nepal alive for future generations.</p>
                </div>

                <div class="text-center group">
                    <div class="mb-6 relative inline-block">
                        <div class="absolute inset-0 bg-amber-100 rounded-full scale-150 opacity-0 group-hover:opacity-100 transition duration-500"></div>
                        <i class="fas fa-gem text-4xl text-amber-800 relative z-10"></i>
                    </div>
                    <h4 class="font-heritage text-xl mb-4 text-amber-900 uppercase tracking-widest">Sacred Quality</h4>
                    <p class="text-gray-500 text-sm leading-relaxed max-w-xs mx-auto">From ceremonial thangkas to daily prayer bowls, every piece is inspected for perfection.</p>
                </div>
            </div>
        </div>
    </section>

    <section class="py-20 bg-stone-50 border-y border-stone-200">
        <div class="container mx-auto px-4">
            <div class="flex flex-col md:flex-row justify-between items-end mb-12 gap-4">
                <div>
                    <h2 class="font-heritage text-2xl text-amber-900 uppercase tracking-[0.2em]">Heritage Collections</h2>
                    <p class="font-serif-italic text-stone-500 text-sm mt-1">Curated Himalayan craftsmanship</p>
                </div>
                <a href="Shop.aspx" class="group flex items-center gap-3 text-[10px] font-bold uppercase tracking-[0.3em] text-amber-700 hover:text-amber-900 transition-all">
                    Explore Collection 
                    <span class="w-8 h-[1px] bg-amber-700 group-hover:w-12 group-hover:bg-amber-900 transition-all"></span>
                </a>
            </div>
            <div class="grid grid-cols-2 md:grid-cols-4 lg:grid-cols-6 gap-4">
                <asp:Repeater ID="rptCategories" runat="server">
                    <ItemTemplate>
                        <a href='Shop.aspx?category=<%# Eval("CategoryID") %>' class="bg-white border border-stone-200 p-8 text-center hover:bg-amber-900 hover:text-white transition-all duration-500 group shadow-sm">
                            <span class="text-[10px] font-bold uppercase tracking-[0.2em]"><%# Eval("CategoryName") %></span>
                        </a>
                    </ItemTemplate>
                </asp:Repeater>
            </div>
        </div>
    </section>

    <section class="py-28 bg-white">
        <div class="container mx-auto px-4">
            <div class="text-center mb-20">
                <h2 class="font-heritage text-3xl text-amber-900 uppercase tracking-widest">Featured Masterpieces</h2>
                <p class="font-serif-italic text-stone-500 mt-2">Selected works from our master craftsmen</p>
            </div>
            <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-12">
                <asp:Repeater ID="rptFeaturedProducts" runat="server">
                    <ItemTemplate>
                        <div class="group relative">
                            <div class="aspect-[4/5] overflow-hidden bg-gray-50 mb-6 border border-stone-100 relative">
                                <img src='<%# ResolveUrl(Eval("ImageUrl").ToString()) %>' 
                                     class="w-full h-full object-cover group-hover:scale-110 transition-transform duration-1000" 
                                     alt='<%# Eval("ProductName") %>' />
                                
                                <div class="absolute inset-0 bg-black/20 opacity-0 group-hover:opacity-100 transition-opacity duration-300 flex items-end">
                                    <asp:LinkButton ID="btnQuickAdd" runat="server" 
                                        CommandArgument='<%# Eval("ProductID") %>' 
                                        OnCommand="AddToCart_Command"
                                        CssClass="w-full bg-amber-900 text-white py-5 text-[10px] font-bold uppercase tracking-widest translate-y-full group-hover:translate-y-0 transition-transform duration-500 flex justify-center items-center gap-2">
                                        Add to Basket <i class="fas fa-plus text-[8px]"></i>
                                    </asp:LinkButton>
                                </div>
                            </div>
                            <div class="text-center">
                                <h3 class="text-[11px] font-bold uppercase tracking-widest text-stone-800 group-hover:text-amber-700 transition-colors">
                                    <%# Eval("ProductName") %>
                                </h3>
                                <p class="text-amber-800 font-bold mt-2 tracking-tighter text-sm">
                                    NPR <%# String.Format("{0:N0}", Eval("Price")) %>
                                </p>
                            </div>
                        </div>
                    </ItemTemplate>
                </asp:Repeater>
            </div>
        </div>
    </section>

    <section class="py-20 bg-white">
        <div class="container mx-auto px-4">
            <div class="max-w-4xl mx-auto border-y border-amber-100 py-12 text-center">
                <i class="fas fa-scroll text-amber-800/20 text-4xl mb-6"></i>
                <h2 class="font-heritage text-2xl text-amber-900 mb-6 italic">"Every stroke of a brush, every chisel of wood, tells a story of a thousand years."</h2>
                <p class="text-stone-500 text-xs uppercase tracking-[0.4em]">Handcrafted in Kathmandu Valley</p>
            </div>
        </div>
    </section>

    <section class="bg-amber-50/50 py-24 border-t border-amber-100">
        <div class="container mx-auto px-4 text-center">
            <h3 class="font-heritage text-3xl text-amber-900 mb-4 uppercase italic tracking-tighter">The Heritage Letter</h3>
            <p class="font-serif-italic text-stone-600 mb-10 max-w-lg mx-auto leading-relaxed">
                Join our inner circle for exclusive artisan previews and Himalayan soul.
            </p>
            <div class="flex flex-col md:flex-row justify-center items-center gap-0 max-w-md mx-auto shadow-xl">
                <input type="email" placeholder="Email Address" 
                       class="w-full px-6 py-4 bg-white border border-amber-200 outline-none focus:border-amber-700 transition-colors italic text-sm" />
                <button type="button" 
                        class="w-full md:w-auto bg-amber-900 text-white px-10 py-4 text-[10px] font-bold uppercase tracking-widest hover:bg-amber-800 transition whitespace-nowrap">
                    Subscribe
                </button>
            </div>
        </div>
    </section>

</asp:Content>