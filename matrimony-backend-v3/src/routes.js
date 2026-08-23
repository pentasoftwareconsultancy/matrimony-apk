import express from "express";
import gbrouter from "./modules/auth/auth.routes.js";
import unifiedLoginRouter from "./modules/auth/unifiedLogin.routes.js";
import contactrouter from './modules/contact/contact.routes.js'
import eventrouter from './modules/event/event.routes.js'
import blogrouter from "./modules/blog/blog.routes.js";
import photographerrouter from './modules/vendors/photographer/photographer.routes.js'
import decorationrouter from './modules/vendors/decoration/decoration.routes.js'
import mehndirouter from './modules/vendors/mehndi/mehndi.routes.js'
import makeuprouter from './modules/vendors/makeup/makeup.routes.js'
import lightingrouter from './modules/vendors/lighting/lighting.routes.js'
import djmusicrouter from './modules/vendors/djmusic/djmusic.routes.js'
import jewelleryrouter from './modules/vendors/jewellery/jewellery.routes.js'
import MessageRoutes from "./modules/message/message.routes.js";
import nearmeRoutes from "./modules/brideGroom/nearme.routes.js";
import NotificationRoutes from "./modules/notification/notification.routes.js";
import favoriteRouters from "./modules/favorite/favorite.routes.js"
import personrouter from './modules/person/person.routes.js'
import MembershipRoutes from "./modules/membership/membership.routes.js";
import adminRouter from "./modules/admin/admin.routes.js";
import MatchesGalleryRouter from "./modules/matchesgallary/matchesgallary.routes.js";
import sponsorRouter from './modules/sponsor/sponsor.routes.js';
import userActionRoutes from './modules/user/useraction.routes.js';

const router = express.Router();

router.use("/bridegroom", gbrouter);
router.use("/auth", unifiedLoginRouter);
router.use('/contactus', contactrouter)
router.use('/events', eventrouter)
router.use('/blog', blogrouter)
router.use('/photographer', photographerrouter)
router.use('/decoration', decorationrouter)
router.use('/mehndi', mehndirouter)
router.use('/makeup', makeuprouter)
router.use('/lighting', lightingrouter)
router.use('/djmusic', djmusicrouter)
router.use('/jewellery', jewelleryrouter)
router.use("/messages", MessageRoutes)
router.use('/nearme', nearmeRoutes)
router.use("/notification", NotificationRoutes)
router.use("/favorite", favoriteRouters)
router.use('/persons', personrouter);
router.use("/membership", MembershipRoutes);
router.use("/sponsor", sponsorRouter);
router.use("/actions", userActionRoutes);  

// admin routes
router.use("/admin", adminRouter);
router.use("/matches-gallery", MatchesGalleryRouter);
export default router;