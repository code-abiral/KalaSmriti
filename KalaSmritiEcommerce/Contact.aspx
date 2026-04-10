<%@ Page Title="Contact Us" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="relative py-28 bg-[#1a140f] overflow-hidden">
        <div class="absolute inset-0 opacity-30">
            <img src="https://www.transparenttextures.com/patterns/carbon-fibre.png" class="w-full h-full object-cover" />
        </div>
        <div class="container mx-auto px-4 text-center relative z-10">
            <span class="text-amber-500 font-bold uppercase tracking-[0.4em] text-[10px] mb-4 block">Connect With Us</span>
            <h1 class="font-heritage text-5xl md:text-6xl text-white mb-4 uppercase tracking-tighter">Seek Our <span class="italic text-amber-200">Counsel</span></h1>
            <p class="font-serif-italic text-amber-100/60 max-w-lg mx-auto leading-relaxed">Whether you seek a custom masterpiece or have inquiries about our heritage collection, our artisans are here to assist.</p>
        </div>
    </div>

    <section class="py-24 bg-stone-50">
        <div class="container mx-auto px-4">
            <div class="grid grid-cols-1 lg:grid-cols-2 gap-20 items-start">
                
                <div class="bg-white border border-stone-200 p-10 md:p-14 shadow-sm">
                    <h2 class="font-heritage text-2xl text-amber-900 mb-8 uppercase tracking-widest border-b border-stone-100 pb-4">Inquiry Form</h2>
                    
                    <div class="space-y-6">
                        <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                            <div>
                                <label class="block text-[10px] font-bold uppercase tracking-widest text-stone-400 mb-2">Full Name</label>
                                <input type="text" class="w-full px-0 py-3 border-b border-stone-200 bg-transparent focus:outline-none focus:border-amber-700 transition-colors italic text-sm text-stone-800" placeholder="e.g. Aarav Sharma" />
                            </div>
                            <div>
                                <label class="block text-[10px] font-bold uppercase tracking-widest text-stone-400 mb-2">Email Address</label>
                                <input type="email" class="w-full px-0 py-3 border-b border-stone-200 bg-transparent focus:outline-none focus:border-amber-700 transition-colors italic text-sm text-stone-800" placeholder="aarav@example.com" />
                            </div>
                        </div>

                        <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                            <div>
                                <label class="block text-[10px] font-bold uppercase tracking-widest text-stone-400 mb-2">Phone</label>
                                <input type="tel" class="w-full px-0 py-3 border-b border-stone-200 bg-transparent focus:outline-none focus:border-amber-700 transition-colors italic text-sm text-stone-800" placeholder="+977-98..." />
                            </div>
                            <div>
                                <label class="block text-[10px] font-bold uppercase tracking-widest text-stone-400 mb-2">Subject</label>
                                <input type="text" class="w-full px-0 py-3 border-b border-stone-200 bg-transparent focus:outline-none focus:border-amber-700 transition-colors italic text-sm text-stone-800" placeholder="Order Inquiry" />
                            </div>
                        </div>

                        <div>
                            <label class="block text-[10px] font-bold uppercase tracking-widest text-stone-400 mb-2">Message</label>
                            <textarea rows="4" class="w-full px-0 py-3 border-b border-stone-200 bg-transparent focus:outline-none focus:border-amber-700 transition-colors italic text-sm text-stone-800 resize-none" placeholder="Tell us about the piece you seek..."></textarea>
                        </div>

                        <button type="button" class="w-full bg-amber-900 text-white py-5 text-[10px] font-bold uppercase tracking-[0.3em] hover:bg-amber-800 transition shadow-lg mt-4 cursor-pointer">
                            Send Message <i class="fas fa-paper-plane ml-2 text-[8px]"></i>
                        </button>
                    </div>
                </div>

                <div class="space-y-12">
                    <div>
                        <h2 class="font-heritage text-2xl text-amber-900 mb-8 uppercase tracking-widest">Our Atelier</h2>
                        
                        <div class="grid grid-cols-1 md:grid-cols-2 gap-10">
                            <div class="flex items-start group">
                                <i class="fas fa-map-marker-alt text-amber-700 mt-1 mr-4 transition-transform group-hover:scale-125"></i>
                                <div>
                                    <h3 class="text-[11px] font-bold uppercase tracking-widest text-stone-800 mb-2">Kathmandu Studio</h3>
                                    <p class="text-stone-500 text-xs leading-relaxed">Thamel, Kathmandu<br/>Bagmati Province, 44600<br/>Nepal</p>
                                </div>
                            </div>

                            <div class="flex items-start group">
                                <i class="fas fa-envelope text-amber-700 mt-1 mr-4 transition-transform group-hover:scale-125"></i>
                                <div>
                                    <h3 class="text-[11px] font-bold uppercase tracking-widest text-stone-800 mb-2">Digital Desk</h3>
                                    <p class="text-stone-500 text-xs leading-relaxed">info@kalasmriti.com<br/>+977-9841234567</p>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="relative h-72 bg-stone-200 overflow-hidden border border-stone-300 shadow-inner">
<iframe 
                            src="https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d14128.188487214736!2d85.30337857211046!3d27.715843477145894!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x39eb18fcb0634f17%3A0x6697079d201e515!2sThamel%2C%20Kathmandu%2044600!5e0!3m2!1sen!2snp!4v1710000000000!5m2!1sen!2snp" 
                            class="w-full h-full grayscale hover:grayscale-0 transition-all duration-1000 border-0" 
                            allowfullscreen="" 
                            loading="lazy">
                        </iframe>
                        <a href="https://maps.app.goo.gl/J7LHqpbJ8RjodjZR6" target="_blank" class="absolute bottom-4 right-4 bg-white/90 backdrop-blur-sm px-4 py-2 text-[9px] font-bold uppercase tracking-widest text-amber-900 border border-stone-200 hover:bg-amber-900 hover:text-white transition-all shadow-sm">
                            Open in Google Maps
                        </a>
                    </div>
                    <div class="pt-8 border-t border-stone-200">
                        <h2 class="font-heritage text-xl text-amber-900 mb-8 uppercase tracking-widest italic">Common Queries</h2>
                        <div class="space-y-6">
                            <details class="group cursor-pointer">
                                <summary class="flex justify-between items-center list-none text-[10px] font-bold uppercase tracking-widest text-stone-700 group-hover:text-amber-800 transition">
                                    Do you offer worldwide shipping?
                                    <span class="text-amber-700 group-open:rotate-45 transition-transform">+</span>
                                </summary>
                                <p class="text-stone-500 text-xs mt-3 leading-relaxed pl-4 border-l border-amber-200 italic">
                                    Yes. We provide secure, insured global shipping. Each piece is custom-crated to survive the journey from the Himalayas to your doorstep.
                                </p>
                            </details>
                            
                            <details class="group cursor-pointer">
                                <summary class="flex justify-between items-center list-none text-[10px] font-bold uppercase tracking-widest text-stone-700 group-hover:text-amber-800 transition">
                                    Are the products authentic & certified?
                                    <span class="text-amber-700 group-open:rotate-45 transition-transform">+</span>
                                </summary>
                                <p class="text-stone-500 text-xs mt-3 leading-relaxed pl-4 border-l border-amber-200 italic">
                                    Every creation is 100% handcrafted by verified local artisans. We provide a Certificate of Authenticity details the materials and heritage lineage.
                                </p>
                            </details>

                            <details class="group cursor-pointer">
                                <summary class="flex justify-between items-center list-none text-[10px] font-bold uppercase tracking-widest text-stone-700 group-hover:text-amber-800 transition">
                                    Can I request a custom commission?
                                    <span class="text-amber-700 group-open:rotate-45 transition-transform">+</span>
                                </summary>
                                <p class="text-stone-500 text-xs mt-3 leading-relaxed pl-4 border-l border-amber-200 italic">
                                    Absolutely. We specialize in bespoke Thangka paintings and bronze castings. Use the form above to describe your vision to our lead artisans.
                                </p>
                            </details>

                            <details class="group cursor-pointer">
                                <summary class="flex justify-between items-center list-none text-[10px] font-bold uppercase tracking-widest text-stone-700 group-hover:text-amber-800 transition">
                                    What is your return policy for art?
                                    <span class="text-amber-700 group-open:rotate-45 transition-transform">+</span>
                                </summary>
                                <p class="text-stone-500 text-xs mt-3 leading-relaxed pl-4 border-l border-amber-200 italic">
                                    We accept returns within 7 days only if the item is damaged during transit. We do not offer returns on custom-commissioned pieces.
                                </p>
                            </details>
                        </div>
                    </div>
                </div>
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
                        class="w-full md:w-auto bg-amber-900 text-white px-10 py-4 text-[10px] font-bold uppercase tracking-widest hover:bg-amber-800 transition whitespace-nowrap cursor-pointer">
                    Subscribe
                </button>
            </div>
        </div>
    </section>
</asp:Content>