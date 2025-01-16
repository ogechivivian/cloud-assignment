using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;

namespace aspnet_core_dotnet_core
{
    public class Startup
    {
        public Startup(IConfiguration configuration)
        {
            Configuration = configuration;
        }

        public IConfiguration Configuration { get; }

        // Register services to the container.
        public void ConfigureServices(IServiceCollection services)
        {
            // Configure Cookie Policy
            services.Configure<CookiePolicyOptions>(options =>
            {
                options.CheckConsentNeeded = context => true;
                options.MinimumSameSitePolicy = SameSiteMode.None;
            });

            // Add Controllers with Views
            services.AddControllersWithViews();

            // Optional: Add Razor Pages
            // services.AddRazorPages();
        }

        // Configure the HTTP request pipeline.
        public void Configure(IApplicationBuilder app, IWebHostEnvironment env)
        {
            if (env.IsDevelopment())
            {
                // Developer exception page for debugging
                app.UseDeveloperExceptionPage();
            }
            else
            {
                // Production exception handler
                app.UseExceptionHandler("/Error");
                // Enforce HTTPS in production
                app.UseHsts();
            }

            // Redirect HTTP to HTTPS
            app.UseHttpsRedirection();

            // Serve static files from wwwroot
            app.UseStaticFiles();

            // Apply Cookie Policy
            app.UseCookiePolicy();

            // Enable Routing
            app.UseRouting();

            // Apply Authorization
            app.UseAuthorization();

            // Configure Endpoints
            app.UseEndpoints(endpoints =>
            {
                // Default route: {controller=Home}/{action=Index}/{id?}
                endpoints.MapControllerRoute(
                    name: "default",
                    pattern: "{controller=Home}/{action=Index}/{id?}");

                // Optional: Map Razor Pages
                // endpoints.MapRazorPages();
            });
        }
    }
}
