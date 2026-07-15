#!/bin/bash
# build-history.sh for history-rewriting practice

set -e
echo "🚀 Building Git history for history rewriting practice..."

GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

if [ -d "src" ]; then
    echo "⚠️ src/ exists. Delete and rebuild? (y/N): "
    read -n 1 -r
    echo
    [[ ! $REPLY =~ ^[Yy]$ ]] && echo "Aborting." && exit 1
    echo -e "${BLUE}🧹 Cleaning up existing practice environment...${NC}"
    git reset --hard origin/master 2>/dev/null || git reset --hard HEAD~20 2>/dev/null || true
    git branch | grep -v "^\*" | grep -v "master" | xargs -r git branch -D 2>/dev/null || true
    rm -rf src/
    echo -e "${GREEN}✅ Cleanup complete${NC}"
    echo ""
fi

echo -e "${BLUE}📁 Creating project structure...${NC}"
mkdir -p src

# Developer 1: Sarah
export GIT_AUTHOR_NAME="Sarah Chen"
export GIT_AUTHOR_EMAIL="sarah@example.com"
export GIT_COMMITTER_NAME="Sarah Chen"
export GIT_COMMITTER_EMAIL="sarah@example.com"

# Commit 1: Store module
export GIT_AUTHOR_DATE="2024-01-10T09:00:00"
export GIT_COMMITTER_DATE="2024-01-10T09:00:00"
cat > src/store.js << 'EOF'
// E-commerce Store
class Store {
    constructor() {
        this.products = [];
    }
    
    initialize() {
        console.log('Store initialized');
    }
}
module.exports = Store;
EOF
git add src/store.js
git commit -m "Add store module"

# Commit 2: Products (typo in message - needs amend)
export GIT_AUTHOR_DATE="2024-01-10T10:00:00"
export GIT_COMMITTER_DATE="2024-01-10T10:00:00"
cat > src/products.js << 'EOF'
// Product catalog
class ProductCatalog {
    constructor() {
        this.items = new Map();
    }
    
    addProduct(id, name, price) {
        this.items.set(id, { name, price });
    }
}
module.exports = ProductCatalog;
EOF
git add src/products.js
git commit -m "Add prodcut catalog (TYPO!)"

# Commit 3: Cart
export GIT_AUTHOR_DATE="2024-01-10T11:00:00"
export GIT_COMMITTER_DATE="2024-01-10T11:00:00"
cat > src/cart.js << 'EOF'
// Shopping cart
class Cart {
    constructor() {
        this.items = [];
    }
    
    addItem(productId, quantity) {
        this.items.push({ productId, quantity });
    }
}
module.exports = Cart;
EOF
git add src/cart.js
git commit -m "Add shopping cart"

# Commit 4: Checkout
export GIT_AUTHOR_DATE="2024-01-10T14:00:00"
export GIT_COMMITTER_DATE="2024-01-10T14:00:00"
cat > src/checkout.js << 'EOF'
// Checkout process
class Checkout {
    constructor(cart) {
        this.cart = cart;
    }
    
    process() {
        console.log('Processing checkout...');
    }
}
module.exports = Checkout;
EOF
git add src/checkout.js
git commit -m "Add checkout process"

# Commit 5: Accidentally commit secret file
export GIT_AUTHOR_DATE="2024-01-11T09:00:00"
export GIT_COMMITTER_DATE="2024-01-11T09:00:00"
cat > src/secrets.txt << 'EOF'
API_KEY=super-secret-key-12345
DATABASE_PASSWORD=dont-commit-this!
EOF
git add src/secrets.txt
git commit -m "Add configuration (OOPS - has secrets!)"

# Commit 6: Payment module
export GIT_AUTHOR_DATE="2024-01-11T10:00:00"
export GIT_COMMITTER_DATE="2024-01-11T10:00:00"
cat > src/payment.js << 'EOF'
// Payment processing
class PaymentProcessor {
    process(amount, method) {
        console.log(\`Processing payment: $${ amount }\`);
        return { status: 'success' };
    }
}
module.exports = PaymentProcessor;
EOF
git add src/payment.js
git commit -m "Add payment processor"

# Commit 7: Users (wrong author email)
export GIT_AUTHOR_NAME="Sarah Chen"
export GIT_AUTHOR_EMAIL="wrong@example.com"
export GIT_COMMITTER_NAME="Sarah Chen"
export GIT_COMMITTER_EMAIL="wrong@example.com"
export GIT_AUTHOR_DATE="2024-01-11T11:00:00"
export GIT_COMMITTER_DATE="2024-01-11T11:00:00"
cat > src/users.js << 'EOF'
// User management
class UserManager {
    constructor() {
        this.users = new Map();
    }
    
    register(username, email) {
        const id = Math.random().toString(36);
        this.users.set(id, { username, email });
        return id;
    }
}
module.exports = UserManager;
EOF
git add src/users.js
git commit -m "Add user management"

# Continue with more commits (some good, some with issues)

# Commit 8: Orders module (correct)
export GIT_AUTHOR_NAME="Sarah Chen"
export GIT_AUTHOR_EMAIL="sarah@example.com"
export GIT_COMMITTER_NAME="Sarah Chen"
export GIT_COMMITTER_EMAIL="sarah@example.com"
export GIT_AUTHOR_DATE="2024-01-11T14:00:00"
export GIT_COMMITTER_DATE="2024-01-11T14:00:00"
cat > src/orders.js << 'EOF'
// Order management
class OrderManager {
    constructor() {
        this.orders = [];
    }
    
    createOrder(userId, items) {
        const order = {
            id: this.generateOrderId(),
            userId,
            items,
            status: 'pending',
            createdAt: new Date()
        };
        this.orders.push(order);
        return order;
    }
    
    generateOrderId() {
        return 'ORDER-' + Math.random().toString(36).substr(2, 9);
    }
}
module.exports = OrderManager;
EOF
git add src/orders.js
git commit -m "Add order management system"

# Commit 9: Inventory (typo in filename - needs fixing)
export GIT_AUTHOR_DATE="2024-01-12T09:00:00"
export GIT_COMMITTER_DATE="2024-01-12T09:00:00"
cat > src/inventry.js << 'EOF'
// Inventory tracking
class Inventory {
    constructor() {
        this.stock = new Map();
    }
    
    updateStock(productId, quantity) {
        this.stock.set(productId, quantity);
    }
    
    checkAvailability(productId) {
        return this.stock.get(productId) || 0;
    }
}
module.exports = Inventory;
EOF
git add src/inventry.js
git commit -m "Add inventory module"

# Commit 10: Shipping (bad commit message)
export GIT_AUTHOR_DATE="2024-01-12T10:00:00"
export GIT_COMMITTER_DATE="2024-01-12T10:00:00"
cat > src/shipping.js << 'EOF'
// Shipping calculator
class ShippingCalculator {
    calculateShipping(weight, destination) {
        const baseRate = 5.00;
        const perKg = 2.50;
        return baseRate + (weight * perKg);
    }
}
module.exports = ShippingCalculator;
EOF
git add src/shipping.js
git commit -m "stuff"

# Commit 11: Discounts
export GIT_AUTHOR_DATE="2024-01-12T11:00:00"
export GIT_COMMITTER_DATE="2024-01-12T11:00:00"
cat > src/discounts.js << 'EOF'
// Discount system
class DiscountManager {
    constructor() {
        this.codes = new Map();
    }
    
    addDiscount(code, percentage) {
        this.codes.set(code, percentage);
    }
    
    applyDiscount(code, amount) {
        const discount = this.codes.get(code);
        if (discount) {
            return amount * (1 - discount / 100);
        }
        return amount;
    }
}
module.exports = DiscountManager;
EOF
git add src/discounts.js
git commit -m "Add discount codes feature"

# Commit 12: Reviews (another typo in message)
export GIT_AUTHOR_DATE="2024-01-12T14:00:00"
export GIT_COMMITTER_DATE="2024-01-12T14:00:00"
cat > src/reviews.js << 'EOF'
// Product reviews
class ReviewManager {
    constructor() {
        this.reviews = [];
    }
    
    addReview(productId, userId, rating, text) {
        this.reviews.push({
            productId,
            userId,
            rating,
            text,
            timestamp: new Date()
        });
    }
    
    getReviews(productId) {
        return this.reviews.filter(r => r.productId === productId);
    }
}
module.exports = ReviewManager;
EOF
git add src/reviews.js
git commit -m "Add reveiw system (TYPO!)"

# Commit 13: Analytics
export GIT_AUTHOR_DATE="2024-01-13T09:00:00"
export GIT_COMMITTER_DATE="2024-01-13T09:00:00"
cat > src/analytics.js << 'EOF'
// Analytics tracking
class Analytics {
    constructor() {
        this.events = [];
    }
    
    trackEvent(event, data) {
        this.events.push({
            event,
            data,
            timestamp: new Date()
        });
    }
    
    getStats() {
        return {
            totalEvents: this.events.length,
            events: this.events
        };
    }
}
module.exports = Analytics;
EOF
git add src/analytics.js
git commit -m "Add analytics module"

# Commit 14: Debug file accidentally committed
export GIT_AUTHOR_DATE="2024-01-13T10:00:00"
export GIT_COMMITTER_DATE="2024-01-13T10:00:00"
cat > debug.log << 'EOF'
DEBUG: Starting application
ERROR: Connection failed
DEBUG: Retrying...
WARNING: Slow query detected
EOF
git add -f debug.log
git commit -m "Add debug output"

# Commit 15: Wishlist
export GIT_AUTHOR_DATE="2024-01-13T11:00:00"
export GIT_COMMITTER_DATE="2024-01-13T11:00:00"
cat > src/wishlist.js << 'EOF'
// Wishlist feature
class Wishlist {
    constructor(userId) {
        this.userId = userId;
        this.items = [];
    }
    
    addItem(productId) {
        if (!this.items.includes(productId)) {
            this.items.push(productId);
        }
    }
    
    removeItem(productId) {
        const index = this.items.indexOf(productId);
        if (index > -1) {
            this.items.splice(index, 1);
        }
    }
}
module.exports = Wishlist;
EOF
git add src/wishlist.js
git commit -m "Add wishlist functionality"

# Commit 16: Search (WIP commit message)
export GIT_AUTHOR_DATE="2024-01-13T14:00:00"
export GIT_COMMITTER_DATE="2024-01-13T14:00:00"
cat > src/search.js << 'EOF'
// Search functionality
class SearchEngine {
    constructor(products) {
        this.products = products;
    }
    
    search(query) {
        const lowerQuery = query.toLowerCase();
        return this.products.filter(p => 
            p.name.toLowerCase().includes(lowerQuery)
        );
    }
}
module.exports = SearchEngine;
EOF
git add src/search.js
git commit -m "WIP search"

# Commit 17: Recommendations
export GIT_AUTHOR_DATE="2024-01-14T09:00:00"
export GIT_COMMITTER_DATE="2024-01-14T09:00:00"
cat > src/recommendations.js << 'EOF'
// Product recommendations
class RecommendationEngine {
    recommend(userId, limit = 5) {
        // Simple recommendation logic
        return [];
    }
}
module.exports = RecommendationEngine;
EOF
git add src/recommendations.js
git commit -m "Add recommendation engine"

# Commit 18: Auth (wrong email again)
export GIT_AUTHOR_EMAIL="wrong-email@test.com"
export GIT_COMMITTER_EMAIL="wrong-email@test.com"
export GIT_AUTHOR_DATE="2024-01-14T10:00:00"
export GIT_COMMITTER_DATE="2024-01-14T10:00:00"
cat > src/auth.js << 'EOF'
// Authentication
class AuthManager {
    constructor() {
        this.sessions = new Map();
    }
    
    login(username, password) {
        // Simplified authentication
        const sessionId = Math.random().toString(36);
        this.sessions.set(sessionId, username);
        return sessionId;
    }
    
    logout(sessionId) {
        this.sessions.delete(sessionId);
    }
}
module.exports = AuthManager;
EOF
git add src/auth.js
git commit -m "Add authentication"

# Fix email back
export GIT_AUTHOR_EMAIL="sarah@example.com"
export GIT_COMMITTER_EMAIL="sarah@example.com"

# Commit 19: Email notifications
export GIT_AUTHOR_DATE="2024-01-14T11:00:00"
export GIT_COMMITTER_DATE="2024-01-14T11:00:00"
cat > src/notifications.js << 'EOF'
// Email notifications
class NotificationService {
    sendOrderConfirmation(email, orderId) {
        console.log(\`Sending confirmation to ${ email }\`);
    }
    
    sendShippingUpdate(email, trackingNumber) {
        console.log(\`Sending tracking to ${ email }\`);
    }
}
module.exports = NotificationService;
EOF
git add src/notifications.js
git commit -m "Add email notifications"

# Commit 20: Temp file accidentally committed
export GIT_AUTHOR_DATE="2024-01-14T14:00:00"
export GIT_COMMITTER_DATE="2024-01-14T14:00:00"
cat > temp_backup.js << 'EOF'
// Temporary backup - DELETE ME
const oldCode = "this should not be committed";
EOF
git add temp_backup.js
git commit -m "Backup old code"

# Commit 21: Reports
export GIT_AUTHOR_DATE="2024-01-15T09:00:00"
export GIT_COMMITTER_DATE="2024-01-15T09:00:00"
cat > src/reports.js << 'EOF'
// Sales reports
class ReportGenerator {
    generateSalesReport(startDate, endDate) {
        return {
            period: \`${ startDate } to ${ endDate }\`,
            totalSales: 0,
            orderCount: 0
        };
    }
}
module.exports = ReportGenerator;
EOF
git add src/reports.js
git commit -m "Add sales reporting"

# Commit 22: Categories (vague commit message)
export GIT_AUTHOR_DATE="2024-01-15T10:00:00"
export GIT_COMMITTER_DATE="2024-01-15T10:00:00"
cat > src/categories.js << 'EOF'
// Product categories
class CategoryManager {
    constructor() {
        this.categories = new Map();
    }
    
    addCategory(name, parent = null) {
        const id = Math.random().toString(36).substr(2, 9);
        this.categories.set(id, { name, parent });
        return id;
    }
}
module.exports = CategoryManager;
EOF
git add src/categories.js
git commit -m "update"

# Commit 23: Tax calculator
export GIT_AUTHOR_DATE="2024-01-15T11:00:00"
export GIT_COMMITTER_DATE="2024-01-15T11:00:00"
cat > src/tax.js << 'EOF'
// Tax calculation
class TaxCalculator {
    calculateTax(amount, region) {
        const rates = {
            'US': 0.08,
            'CA': 0.13,
            'UK': 0.20
        };
        return amount * (rates[region] || 0);
    }
}
module.exports = TaxCalculator;
EOF
git add src/tax.js
git commit -m "Add tax calculation"

# Commit 24: Coupons (typo in code)
export GIT_AUTHOR_DATE="2024-01-15T14:00:00"
export GIT_COMMITTER_DATE="2024-01-15T14:00:00"
cat > src/coupons.js << 'EOF'
// Coupon system
class CouponManger {  // TYPO: should be Manager
    constructor() {
        this.coupons = [];
    }
    
    validate(code) {
        return this.coupons.find(c => c.code === code);
    }
}
module.exports = CouponManger;
EOF
git add src/coupons.js
git commit -m "Add coupon system"

# Commit 25: Returns
export GIT_AUTHOR_DATE="2024-01-16T09:00:00"
export GIT_COMMITTER_DATE="2024-01-16T09:00:00"
cat > src/returns.js << 'EOF'
// Return/refund processing
class ReturnManager {
    processReturn(orderId, reason) {
        return {
            returnId: 'RET-' + Math.random().toString(36).substr(2, 9),
            status: 'processing',
            orderId,
            reason
        };
    }
}
module.exports = ReturnManager;
EOF
git add src/returns.js
git commit -m "Add return processing"

# Commit 26: Addresses
export GIT_AUTHOR_DATE="2024-01-16T10:00:00"
export GIT_COMMITTER_DATE="2024-01-16T10:00:00"
cat > src/addresses.js << 'EOF'
// Address management
class AddressBook {
    constructor(userId) {
        this.userId = userId;
        this.addresses = [];
    }
    
    addAddress(address) {
        this.addresses.push({
            id: Math.random().toString(36).substr(2, 9),
            ...address,
            createdAt: new Date()
        });
    }
}
module.exports = AddressBook;
EOF
git add src/addresses.js
git commit -m "Add address book"

# Commit 27: TODO comment committed
export GIT_AUTHOR_DATE="2024-01-16T11:00:00"
export GIT_COMMITTER_DATE="2024-01-16T11:00:00"
cat > src/promotions.js << 'EOF'
// Promotional campaigns
class PromotionManager {
    // TODO: Fix this before release!!!
    // TODO: Remove hardcoded values
    applyPromotion(orderId) {
        console.log('Applying promotion...');
        // FIXME: This is broken
        return true;
    }
}
module.exports = PromotionManager;
EOF
git add src/promotions.js
git commit -m "Add promotions (needs cleanup)"

# Commit 28: Filters
export GIT_AUTHOR_DATE="2024-01-16T14:00:00"
export GIT_COMMITTER_DATE="2024-01-16T14:00:00"
cat > src/filters.js << 'EOF'
// Product filtering
class ProductFilter {
    filterByPrice(products, min, max) {
        return products.filter(p => 
            p.price >= min && p.price <= max
        );
    }
    
    filterByCategory(products, category) {
        return products.filter(p => p.category === category);
    }
}
module.exports = ProductFilter;
EOF
git add src/filters.js
git commit -m "Add product filters"

# Commit 29: Config file with sensitive data
export GIT_AUTHOR_DATE="2024-01-17T09:00:00"
export GIT_COMMITTER_DATE="2024-01-17T09:00:00"
cat > config.json << 'EOF'
{
  "database": {
    "host": "localhost",
    "port": 5432,
    "username": "admin",
    "password": "super_secret_password_123"
  },
  "api": {
    "key": "sk_live_secret_key_12345"
  }
}
EOF
git add config.json
git commit -m "Add configuration file"

# Commit 30: Pagination
export GIT_AUTHOR_DATE="2024-01-17T10:00:00"
export GIT_COMMITTER_DATE="2024-01-17T10:00:00"
cat > src/pagination.js << 'EOF'
// Pagination helper
class Paginator {
    paginate(items, page, perPage) {
        const start = (page - 1) * perPage;
        const end = start + perPage;
        return {
            items: items.slice(start, end),
            page,
            totalPages: Math.ceil(items.length / perPage)
        };
    }
}
module.exports = Paginator;
EOF
git add src/pagination.js
git commit -m "Add pagination"

# Commit 31: Sorting (ALL CAPS commit message)
export GIT_AUTHOR_DATE="2024-01-17T11:00:00"
export GIT_COMMITTER_DATE="2024-01-17T11:00:00"
cat > src/sorting.js << 'EOF'
// Sorting utilities
class Sorter {
    sortByPrice(products, ascending = true) {
        return products.sort((a, b) => 
            ascending ? a.price - b.price : b.price - a.price
        );
    }
    
    sortByRating(products) {
        return products.sort((a, b) => b.rating - a.rating);
    }
}
module.exports = Sorter;
EOF
git add src/sorting.js
git commit -m "ADD SORTING FEATURES!!!"

# Commit 32: Image handler
export GIT_AUTHOR_DATE="2024-01-17T14:00:00"
export GIT_COMMITTER_DATE="2024-01-17T14:00:00"
cat > src/images.js << 'EOF'
// Image handling
class ImageHandler {
    uploadImage(file) {
        return {
            url: \`/uploads/${ file.name }\`,
            uploadedAt: new Date()
        };
    }
    
    resizeImage(url, width, height) {
        return \`${ url }?w=${ width }&h=${ height }\`;
    }
}
module.exports = ImageHandler;
EOF
git add src/images.js
git commit -m "Add image handling"

# Commit 33: Cache (different author)
export GIT_AUTHOR_NAME="Mike Johnson"
export GIT_AUTHOR_EMAIL="mike@example.com"
export GIT_COMMITTER_NAME="Mike Johnson"
export GIT_COMMITTER_EMAIL="mike@example.com"
export GIT_AUTHOR_DATE="2024-01-18T09:00:00"
export GIT_COMMITTER_DATE="2024-01-18T09:00:00"
cat > src/cache.js << 'EOF'
// Caching layer
class Cache {
    constructor() {
        this.store = new Map();
    }
    
    set(key, value, ttl = 3600) {
        this.store.set(key, {
            value,
            expires: Date.now() + (ttl * 1000)
        });
    }
    
    get(key) {
        const item = this.store.get(key);
        if (item && Date.now() < item.expires) {
            return item.value;
        }
        return null;
    }
}
module.exports = Cache;
EOF
git add src/cache.js
git commit -m "Add caching"

# Commit 34: Logger
export GIT_AUTHOR_DATE="2024-01-18T10:00:00"
export GIT_COMMITTER_DATE="2024-01-18T10:00:00"
cat > src/logger.js << 'EOF'
// Logging utility
class Logger {
    log(level, message) {
        console.log(\`[${ level }] ${ new Date().toISOString() }: ${ message }\`);
    }
    
    error(message) {
        this.log('ERROR', message);
    }
    
    info(message) {
        this.log('INFO', message);
    }
}
module.exports = Logger;
EOF
git add src/logger.js
git commit -m "Add logging"

# Back to Sarah
export GIT_AUTHOR_NAME="Sarah Chen"
export GIT_AUTHOR_EMAIL="sarah@example.com"
export GIT_COMMITTER_NAME="Sarah Chen"
export GIT_COMMITTER_EMAIL="sarah@example.com"

# Commit 35: Validators
export GIT_AUTHOR_DATE="2024-01-18T11:00:00"
export GIT_COMMITTER_DATE="2024-01-18T11:00:00"
cat > src/validators.js << 'EOF'
// Input validation
class Validator {
    validateEmail(email) {
        return /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email);
    }
    
    validatePassword(password) {
        return password.length >= 8;
    }
    
    validatePhone(phone) {
        return /^\d{10}$/.test(phone);
    }
}
module.exports = Validator;
EOF
git add src/validators.js
git commit -m "Add input validators"

# Commit 36: API client
export GIT_AUTHOR_DATE="2024-01-18T14:00:00"
export GIT_COMMITTER_DATE="2024-01-18T14:00:00"
cat > src/api-client.js << 'EOF'
// API client
class APIClient {
    constructor(baseURL) {
        this.baseURL = baseURL;
    }
    
    async get(endpoint) {
        const response = await fetch(\`${ this.baseURL }${ endpoint }\`);
        return response.json();
    }
    
    async post(endpoint, data) {
        const response = await fetch(\`${ this.baseURL }${ endpoint }\`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify(data)
        });
        return response.json();
    }
}
module.exports = APIClient;
EOF
git add src/api-client.js
git commit -m "Add API client"

# Commit 37: Rate limiter
export GIT_AUTHOR_DATE="2024-01-19T09:00:00"
export GIT_COMMITTER_DATE="2024-01-19T09:00:00"
cat > src/rate-limiter.js << 'EOF'
// Rate limiting
class RateLimiter {
    constructor(maxRequests, windowMs) {
        this.maxRequests = maxRequests;
        this.windowMs = windowMs;
        this.requests = new Map();
    }
    
    isAllowed(clientId) {
        const now = Date.now();
        const clientRequests = this.requests.get(clientId) || [];
        const recentRequests = clientRequests.filter(time => 
            now - time < this.windowMs
        );
        
        if (recentRequests.length >= this.maxRequests) {
            return false;
        }
        
        recentRequests.push(now);
        this.requests.set(clientId, recentRequests);
        return true;
    }
}
module.exports = RateLimiter;
EOF
git add src/rate-limiter.js
git commit -m "Add rate limiting"

# Commit 38: Session manager
export GIT_AUTHOR_DATE="2024-01-19T10:00:00"
export GIT_COMMITTER_DATE="2024-01-19T10:00:00"
cat > src/sessions.js << 'EOF'
// Session management
class SessionManager {
    constructor() {
        this.sessions = new Map();
    }
    
    create(userId) {
        const sessionId = Math.random().toString(36).substr(2);
        this.sessions.set(sessionId, {
            userId,
            createdAt: Date.now(),
            expiresAt: Date.now() + (24 * 60 * 60 * 1000)
        });
        return sessionId;
    }
    
    validate(sessionId) {
        const session = this.sessions.get(sessionId);
        return session && Date.now() < session.expiresAt;
    }
}
module.exports = SessionManager;
EOF
git add src/sessions.js
git commit -m "Add session management"

# Commit 39: Utils (messy code - needs squashing later)
export GIT_AUTHOR_DATE="2024-01-19T11:00:00"
export GIT_COMMITTER_DATE="2024-01-19T11:00:00"
cat > src/utils.js << 'EOF'
// Utilities
function formatPrice(price) {
    return \`$$${ price.toFixed(2) }\`;
}

function formatDate(date) {
    return date.toLocaleDateString();
}

module.exports = { formatPrice, formatDate };
EOF
git add src/utils.js
git commit -m "WIP utils"

# Commit 40: Utils addition
export GIT_AUTHOR_DATE="2024-01-19T11:15:00"
export GIT_COMMITTER_DATE="2024-01-19T11:15:00"
cat >> src/utils.js << 'EOF'

function truncate(text, length) {
    return text.length > length ? text.substr(0, length) + '...' : text;
}

module.exports = { formatPrice, formatDate, truncate };
EOF
git add src/utils.js
git commit -m "Add more utils"

echo -e "${GREEN}✅ History setup complete!${NC}"
echo ""
echo -e "${BLUE}📊 Repository contains 40 commits with various issues:${NC}"
echo "  • Commits with typos in messages"
echo "  • Commits with wrong author emails"
echo "  • Commits with secrets/sensitive data"
echo "  • Commits with debug/temp files"
echo "  • Commits with vague messages"
echo "  • Commits with ALL CAPS"
echo "  • Multiple WIP commits that should be squashed"
echo "  • Typos in filenames"
echo ""
echo -e "${BLUE}🎯 Ready for exercises!${NC}"
echo "  Start with: EXERCISES.md"
