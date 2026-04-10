<%@ Page Title="Our Legacy - About Us" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .heritage-border {
            border: 1px solid rgba(180, 83, 9, 0.2);
        }
        .text-justify { text-align: justify; }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <section class="relative h-[60vh] flex items-center overflow-hidden">
        <div class="absolute inset-0 z-0">
            <img src="https://images.unsplash.com/photo-1582555172866-f73bb12a2ab3?q=80&w=1600" 
                 class="w-full h-full object-cover brightness-[0.35]" alt="Artisan at work" />
        </div>
        <div class="container mx-auto px-4 relative z-10 text-center">
            <span class="text-amber-400 font-bold uppercase tracking-[0.5em] text-[10px] mb-4 block">Established 2020</span>
            <h1 class="font-heritage text-5xl md:text-7xl text-white mb-4 leading-tight">Our <span class="italic text-amber-200">Legacy</span></h1>
            <p class="font-serif-italic text-amber-50 text-xl opacity-80 max-w-2xl mx-auto">Bridging the gap between ancient craftsmanship and the modern home.</p>
        </div>
    </section>

    <section class="py-24 bg-white">
        <div class="container mx-auto px-4">
            <div class="grid grid-cols-1 lg:grid-cols-2 gap-20 items-center">
                <div class="space-y-8">
                    <div>
                        <h2 class="font-heritage text-3xl text-amber-900 mb-6 uppercase tracking-widest">A Journey Through Time</h2>
                        <div class="w-12 h-[2px] bg-amber-800 mb-8"></div>
                    </div>
                    <div class="space-y-6 text-stone-600 leading-loose text-sm uppercase tracking-widest opacity-90">
                        <p>KalaSmriti was born in the heart of the Kathmandu Valley, inspired by the silent stories etched into the wood of ancient temples and the vibrant colors of sacred Thangkas.</p>
                        <p>Our mission is simple yet profound: to ensure that the centuries-old techniques of Newari and Himalayan artisans do not just survive, but flourish in a global landscape.</p>
                        <p class="font-serif-italic normal-case text-lg text-amber-900 italic">"We don't just sell art; we preserve the pulse of a civilization."</p>
                    </div>
                </div>
                <div class="relative p-8">
                    <div class="absolute inset-0 border border-amber-100 translate-x-4 translate-y-4 -z-10"></div>
                    <img src="https://images.unsplash.com/photo-1605721911519-3dfeb3be25e7?q=80&w=800" alt="Nepal Craft" class="w-full h-auto grayscale hover:grayscale-0 transition-all duration-700 shadow-2xl" />
                </div>
            </div>
        </div>
    </section>

    <section class="py-24 bg-stone-50 border-y border-stone-100">
        <div class="container mx-auto px-4">
            <div class="grid grid-cols-1 md:grid-cols-2 gap-12">
                <div class="bg-white p-12 border border-amber-50 shadow-sm text-center">
                    <span class="text-amber-800/20 text-6xl block mb-6"><i class="fas fa-om"></i></span>
                    <h3 class="font-heritage text-xl text-amber-900 mb-6 uppercase tracking-widest">Our Mission</h3>
                    <p class="text-stone-500 text-xs uppercase tracking-[0.2em] leading-relaxed">To empower artisan communities by providing a sustainable stage for their mastery, ensuring cultural heritage is valued and protected globally.</p>
                </div>
                <div class="bg-white p-12 border border-amber-50 shadow-sm text-center">
                    <span class="text-amber-800/20 text-6xl block mb-6"><i class="fas fa-eye"></i></span>
                    <h3 class="font-heritage text-xl text-amber-900 mb-6 uppercase tracking-widest">Our Vision</h3>
                    <p class="text-stone-500 text-xs uppercase tracking-[0.2em] leading-relaxed">To be the global beacon for Himalayan craftsmanship, where every home can house a piece of sacred history and every artisan is recognized as a master.</p>
                </div>
            </div>
        </div>
    </section>

    <section class="py-20 bg-[#1a120b] text-[#d4ad6a]">
        <div class="container mx-auto px-4">
            <div class="grid grid-cols-2 md:grid-cols-4 gap-12 text-center">
                <div>
                    <div class="font-heritage text-4xl mb-2">500+</div>
                    <div class="text-[9px] uppercase tracking-[0.4em] opacity-60">Master Artisans</div>
                </div>
                <div>
                    <div class="font-heritage text-4xl mb-2">2000+</div>
                    <div class="text-[9px] uppercase tracking-[0.4em] opacity-60">Handcrafted Works</div>
                </div>
                <div>
                    <div class="font-heritage text-4xl mb-2">10K+</div>
                    <div class="text-[9px] uppercase tracking-[0.4em] opacity-60">Global Homes</div>
                </div>
                <div>
                    <div class="font-heritage text-4xl mb-2">50+</div>
                    <div class="text-[9px] uppercase tracking-[0.4em] opacity-60">Nations Reached</div>
                </div>
            </div>
        </div>
    </section>

    <section class="py-24 bg-white">
        <div class="container mx-auto px-4">
            <h2 class="font-heritage text-3xl text-center text-amber-900 mb-20 uppercase tracking-widest">Core Philosophies</h2>
            <div class="grid grid-cols-1 md:grid-cols-3 gap-16">
                <div class="text-center group">
                    <i class="fas fa-certificate text-3xl text-amber-800/30 mb-6 group-hover:text-amber-800 transition-colors"></i>
                    <h3 class="font-heritage text-sm text-gray-800 mb-4 uppercase tracking-widest font-bold">Absolute Purity</h3>
                    <p class="text-stone-500 text-[11px] uppercase tracking-widest leading-loose">Every item is verified for material authenticity and traditional technique.</p>
                </div>
                <div class="text-center group">
                    <i class="fas fa-hands-helping text-3xl text-amber-800/30 mb-6 group-hover:text-amber-800 transition-colors"></i>
                    <h3 class="font-heritage text-sm text-gray-800 mb-4 uppercase tracking-widest font-bold">Ethical Sourcing</h3>
                    <p class="text-stone-500 text-[11px] uppercase tracking-widest leading-loose">We ensure fair trade practices that directly benefit the families of our craftsmen.</p>
                </div>
                <div class="text-center group">
                    <i class="fas fa-heart text-3xl text-amber-800/30 mb-6 group-hover:text-amber-800 transition-colors"></i>
                    <h3 class="font-heritage text-sm text-gray-800 mb-4 uppercase tracking-widest font-bold">Legacy Preservation</h3>
                    <p class="text-stone-500 text-[11px] uppercase tracking-widest leading-loose">A portion of every sale goes toward training the next generation of Newari artisans.</p>
                </div>
            </div>
        </div>
    </section>

    <section class="py-24 bg-amber-50/30 border-t border-amber-100">
        <div class="container mx-auto px-4 text-center">
            <h2 class="font-heritage text-3xl text-amber-900 mb-6 uppercase tracking-tighter">Become Part of the Story</h2>
            <p class="font-serif-italic text-stone-600 text-lg mb-10 max-w-xl mx-auto">Own a masterpiece that transcends time and supports a heritage that matters.</p>
            <a href="Shop.aspx" class="inline-block bg-amber-900 text-white px-12 py-4 text-[10px] font-bold uppercase tracking-[0.3em] hover:bg-amber-800 transition-all shadow-xl hover:-translate-y-1">
                Explore the Collection
            </a>
        </div>
    </section>
</asp:Content>