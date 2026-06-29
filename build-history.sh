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
    rm -rf src/
    git branch | grep -v "^\*" | grep -v "master" | xargs -r git branch -D 2>/dev/null || true
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

echo -e "${GREEN}✅ History setup complete!${NC}"
echo ""
echo -e "${BLUE}📊 Repository contains:${NC}"
echo "  • 7 commits on master"
echo "  • 1 commit with typo in message (needs amend)"
echo "  • 1 commit with secrets file (needs removal)"
echo "  • 1 commit with wrong author (needs fixing)"
echo ""
echo -e "${BLUE}🎯 Ready for exercises!${NC}"
echo "  Start with: EXERCISES.md"
