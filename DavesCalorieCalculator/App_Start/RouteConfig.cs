using System;
using System.Collections.Generic;
using System.Web;
using System.Web.Routing;
using System.Web.UI;
using Microsoft.AspNet.FriendlyUrls;
using Microsoft.AspNet.FriendlyUrls.Resolvers;

namespace DavesCalorieCalculator
{
    public static class RouteConfig
    {

        public class BugFixFriendlyUrlResolver : WebFormsFriendlyUrlResolver
        {
            protected override bool TrySetMobileMasterPage(HttpContextBase httpContext, Page page, string mobileSuffix)
            {
                return false; // Disable any mobile master page fallback
            }
        }

        public static void RegisterRoutes(RouteCollection routes)
        {
            var settings = new FriendlyUrlSettings
            {
                AutoRedirectMode = RedirectMode.Off  // Prevent any mobile URL redirects
            };
            routes.EnableFriendlyUrls(settings, new BugFixFriendlyUrlResolver());
        }

    }

}
