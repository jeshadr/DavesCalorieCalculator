<%@ Page Title="Build Your Meal" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="DavesCalorieCalculator._Default" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <div class="background-fixed"></div>
    <script>
        let cart = [];
        let selectedMeal = "";
        let selectedCalories = "";
        let selectedSpiceCount = 1;
        let selectedShake = "";
        let selectedShakeSizes = {};

        function updateCartUI() {
            const cartList = document.getElementById("cartList");
            const totalCalories = document.getElementById("totalCalories");
            const totalPrice = document.getElementById("totalPrice");

            cartList.innerHTML = "";
            let total = 0;
            let price = 0;

            cart.forEach((item, index) => {
                const li = document.createElement("li");
                li.style.display = "flex";
                li.style.justifyContent = "space-between";
                li.style.alignItems = "center";
                li.style.marginBottom = "8px";
                li.style.gap = "10px";
                li.style.padding = "6px 10px";
                li.style.border = "1px solid #ccc";
                li.style.borderRadius = "6px";
                li.style.backgroundColor = "#f9f9f9";

                const textSpan = document.createElement("span");
                textSpan.style.flex = "1";
                textSpan.style.fontSize = "14px";
                textSpan.style.wordBreak = "break-word";

                let itemText = item.name;
                if (item.spice && item.spice !== "N/A") {
                    itemText += ` (${item.spice})`;
                }
                itemText += ` - ${item.calories} cal`;
                textSpan.textContent = itemText;

                const removeBtn = document.createElement("button");
                removeBtn.textContent = "×";
                removeBtn.style.background = "#e60023";
                removeBtn.style.color = "white";
                removeBtn.style.border = "none";
                removeBtn.style.borderRadius = "50%";
                removeBtn.style.width = "24px";
                removeBtn.style.height = "24px";
                removeBtn.style.fontSize = "16px";
                removeBtn.style.lineHeight = "24px";
                removeBtn.style.padding = "0";
                removeBtn.style.cursor = "pointer";
                removeBtn.style.flexShrink = "0";

                removeBtn.onclick = () => {
                    cart.splice(index, 1);
                    updateCartUI();
                };

                li.appendChild(textSpan);
                li.appendChild(removeBtn);
                cartList.appendChild(li);

                total += item.calories;
                price += item.price;
            });

            totalCalories.textContent = `Total Calories: ${total}`;
            totalPrice.textContent = `Total Price: $${price.toFixed(2)}`;
        }

        function addSideToCart(mealName, calories, price) {
            cart.push({
                name: mealName,
                spice: "N/A",
                calories: calories,
                price: price
            });

            updateCartUI();
        }

        function showSpiceModal(mealName, calRange, spiceCount = 1, price = 0) {
            selectedMeal = mealName;
            selectedCalories = calRange;
            selectedSpiceCount = spiceCount;
            selectedPrice = price;

            document.getElementById("mealNameDisplay").innerText = mealName;
            document.getElementById("spiceModal").style.display = "flex";
        }

        function showShakeModal(shakeName, sizes) {
            selectedShake = shakeName;
            selectedShakeSizes = sizes;
            document.getElementById("shakeNameDisplay").innerText = shakeName;
            document.getElementById("shakeModal").style.display = "flex";
        }

        function closeShakeModal() {
            document.getElementById("shakeModal").style.display = "none";
        }

        function selectShakeSize(size) {
            const shakeData = selectedShakeSizes[size];
            cart.push({
                name: selectedShake,
                spice: size,
                calories: shakeData.cal,
                price: shakeData.price
            });
            updateCartUI();
            closeShakeModal();
        }

        function closeModal() {
            document.getElementById("spiceModal").style.display = "none";
        }

        function selectSpice(group) {
            const [low, high] = selectedCalories.split('-').map(c => parseInt(c.trim()));
            let calories;

            if (group === "Low") {
                calories = low;
            } else {
                calories = low + (60 * selectedSpiceCount);
            }

            cart.push({
                name: selectedMeal,
                spice: group === "Low" ? "No Spice / Light Mild" : "Mild to Reaper",
                calories: calories,
                price: selectedPrice
            });

            updateCartUI();
            closeModal();
        }
    </script>

    <style>
        body {
            margin: 0;
            padding: 0;
        }

        .background-fixed {
            position: fixed;
            top: 0;
            left: 0;
            width: 100vw;
            height: 100vh;
            z-index: -1;
            background-image: url('./Assets/daves_bg.png');
            background-size: cover;
            background-repeat: no-repeat;
            background-position: center top;
        }

        .top-bar-logo {
            height: 60px;
            margin-top: 10px;
        }

        .card-container {
            display: flex;
            flex-direction: row;
            gap: 20px;
            overflow-x: auto;
            padding-bottom: 10px;
            scroll-snap-type: x mandatory;
        }

        .card-container::-webkit-scrollbar {
            display: none;
        }

        .product-card {
            scroll-snap-align: start;
            flex: 0 0 auto;
            width: 250px;
            border: 1px solid #ccc;
            border-radius: 8px;
            width: 250px;
            background-color: white;
            overflow: hidden;
            display: flex;
            flex-direction: column;
            padding: 0;
        }

        .product-card img {
            width: 100%;
            height: auto;
            display: block;
            border-top-left-radius: 8px;
            border-top-right-radius: 8px;
        }

        .product-info {
            padding: 12px;
            display: flex;
            flex-direction: column;
            gap: 8px;
        }

        .product-info h3 {
            font-size: 16px;
            margin: 0;
        }

        .product-info div {
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .title-bold {
            margin-top: 40px;
            font-weight: bold;
            font-size: 24px;
        }

        .product-info button {
            width: 32px;
            height: 32px;
            border-radius: 50%;
            border: 2px solid #e60023;
            background-color: white;
            color: black;
            font-size: 18px;
            font-weight: bold;
            padding: 0;
            display: flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            transition: all 0.2s ease;
        }

        .modal-overlay {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0, 0, 0, 0.6);
            display: flex;
            align-items: center;
            justify-content: center;
            z-index: 999;
        }

        .modal-content {
            background: white;
            padding: 30px;
            border-radius: 8px;
            text-align: center;
            width: 300px;
        }

        .spice-option {
            width: 100%;
            margin: 10px 0;
            padding: 10px;
            font-weight: bold;
            border: 2px solid #e60023;
            background-color: white;
            color: black;
            cursor: pointer;
            transition: all 0.2s ease;
        }

        .spice-option:hover {
            background-color: #e60023;
            color: white;
        }
    </style>

    <!-- Top bar -->
    <div class="top-bar">
        <img src="./Assets/jeshads_cal_logoT.png" alt="Logo" class="top-bar-logo" />
    </div>

    <div style="background: rgba(255, 255, 255, 0.9); padding: 20px; border-radius: 8px; margin-top: 10px; max-width: 600px;">
        <p style="margin: 0; font-size: 16px; color: #333;">
            Welcome to Dave’s Calorie Calculator — a simple tool to help you estimate the total calories in your meal at Dave’s Hot Chicken. 
            <br /><br />
            Select any combo or side using the <strong>“+”</strong> buttons. If it's a chicken item, you'll be prompted to choose your spice level. 
            The calorie total will adjust based on how spicy you go.
            <br /><br />
            You can view your meal below, remove items anytime, and keep track of your total calorie count before you order.
        </p>
    </div>

    <div class="title-bold">
        <span>COMBOS</span>
    </div>
    <!-- Combo Meals -->
    <div class="scroll-section">
    <div class="card-container">

        <!-- Dave's Combo #1 -->
        <div class="product-card">
            <img src="./Assets/daves_meal1.jpg" alt="" />
            <div class="product-info">
                <h3>Dave's Combo #1: 2 Tenders w/ Fries</h3>
                <div>
                    <span>$12.29</span>
                    <span>1230-1350 cal</span>
                    <button type="button" onclick="showSpiceModal('Dave\'s Combo #1: 2 Tenders w/ Fries', '1230-1350', 2, 12.29)">+</button>
                </div>

            </div>
        </div>

        <!-- Dave's Combo #2 -->
        <div class="product-card">
            <img src="./Assets/daves_meal2.jpg" alt="" />
            <div class="product-info">
                <h3>Dave's Combo #2: 2 Sliders w/ Fries</h3>
                <div>
                    <span>$14.29</span>
                    <span>1500-1620 cal</span>
                    <button type="button" onclick="showSpiceModal('Dave\'s Combo #2: 2 Sliders w/ Fries', '1500-1620', 2, 14.29)">+</button>
                </div>
            </div>
        </div>

        <!-- Dave's Combo #3 -->
        <div class="product-card">
            <img src="./Assets/daves_meal3.jpg" alt="" />
            <div class="product-info">
                <h3>Dave's Combo #3: 1 Tender & Slider w/ Fries</h3>
                <div>
                    <span>$13.29</span>
                    <span>1370-1490 cal</span>
                    <button type="button" onclick="showSpiceModal('Dave\'s Combo #3: 1 Tender & Slider w/ Fries', '1370-1490', 2, 13.29)">+</button>
                </div>
            </div>
        </div>

        <!-- Dave's Combo #4 -->
        <div class="product-card">
            <img src="./Assets/daves_meal4.jpg" alt="" />
            <div class="product-info">
                <h3>Dave's Combo #4: 1 Slider w/ Fries</h3>
                <div>
                    <span>$9.99</span>
                    <span>1060-1120 cal</span>
                    <button type="button" onclick="showSpiceModal('Dave\'s Combo #4: 1 Slider w/ Fries', '1060-1120', 1, 9.99)">+</button>
                </div>
            </div>
        </div>

    </div>
</div>


    <div class="title-bold">
        <span>SIDES</span>
    </div>

    <!-- Sides -->
    <div class="card-container">

        <!-- Mac & Cheese -->
        <div class="product-card">
            <img src="./Assets/mac.jpg" alt="" />
            <div class="product-info">
                <h3>Mac & Cheese</h3>
                <div>
                    <span>$3.69</span>
                    <span>290 cal</span>
                    <button type="button" onclick="addSideToCart('Mac & Cheese', 290, 3.69)">+</button>
                </div>
            </div>
        </div>

        <!-- Fries -->
        <div class="product-card">
            <img src="./Assets/fries.jpg" alt="" />
            <div class="product-info">
                <h3>Fries</h3>
                <div>
                    <span>$3.69</span>
                    <span>440 cal</span>
                    <button type="button" onclick="addSideToCart('Fries', 440, 3.69)">+</button>
                </div>
            </div>
        </div>

        <!-- Cheese Fries -->
        <div class="product-card">
            <img src="./Assets/cheeseFries.jpg" alt="" />
            <div class="product-info">
                <h3>Cheese Fries</h3>
                <div>
                    <span>$4.99</span>
                    <span>460 cal</span>
                    <button type="button" onclick="addSideToCart('Cheese Fries', 460, 4.99)">+</button>
                </div>
            </div>
        </div>

        <!-- Kale Slaw -->
        <div class="product-card">
            <img src="./Assets/kaleslaw.jpg" alt="" />
            <div class="product-info">
                <h3>Kale Slaw</h3>
                <div>
                    <span>$3.69</span>
                    <span>270 cal</span>
                    <button type="button" onclick="addSideToCart('Kale Slaw', 270, 3.69)">+</button>
                </div>
            </div>
        </div>

        <!-- Side of Dave's Sauce -->
        <div class="product-card">
            <img src="./Assets/sauce.jpg" alt="" />
            <div class="product-info">
                <h3>Side of Dave's Sauce</h3>
                <div>
                    <span>$0.25</span>
                    <span>180 cal</span>
                    <button type="button" onclick="addSideToCart('Side of Dave\'s Sauce', 180, 0.25)">+</button>
                </div>
            </div>
        </div>

        <!-- Side of Cheese Sauce -->
        <div class="product-card">
            <img src="./Assets/cheeseSauce.jpg" alt="" />
            <div class="product-info">
                <h3>Side of Cheese Sauce</h3>
                <div>
                    <span>$0.59</span>
                    <span>70 cal</span>
                    <button type="button" onclick="addSideToCart('Side of Cheese Sauce', 70, 0.59)">+</button>
                </div>
            </div>
        </div>

        <!-- Large Dave's Sauce -->
        <div class="product-card">
            <img src="./Assets/largeSauce.jpg" alt="" />
            <div class="product-info">
                <h3>Large Dave's Sauce</h3>
                <div>
                    <span>$2.99</span>
                    <span>1530 cal</span>
                    <button type="button" onclick="addSideToCart('Large Dave\'s Sauce', 720, 2.99)">+</button>
                </div>
            </div>
        </div>

        <!-- Single Tender -->
        <div class="product-card">
            <img src="./Assets/singleTender.jpg" alt="" />
            <div class="product-info">
                <h3>Single Tender</h3>
                <div>
                    <span>$4.79</span>
                    <span>490-550 cal</span>
                    <button type="button" onclick="showSpiceModal('Single Tender', '490-550', 1, 4.79)">+</button>
                </div>
            </div>
        </div>

        <!-- Single Slider -->
        <div class="product-card">
            <img src="./Assets/singleSlider.jpg" alt="" />
            <div class="product-info">
                <h3>Single Slider</h3>
                <div>
                    <span>$6.69</span>
                    <span>620-680 cal</span>
                    <button type="button" onclick="showSpiceModal('Single Slider', '620-680', 1, 6.69)">+</button>
                </div>
            </div>
        </div>
    </div>

    <!-- Milkshakes -->
    <div class="title-bold">
        <span>SHAKES</span>
    </div>

<div class="card-container">

    <!-- Chocolate Shake -->
    <div class="product-card">
        <img src="./Assets/choco_shake.jpg" alt="" />
        <div class="product-info">
            <h3>Chocolate Shake</h3>
            <div>
                <span>$3.69-$7.49</span>
                <span>610-1208 cal</span>
                <button type="button" onclick="showShakeModal('Chocolate Shake', {
                Small: {cal: 610, price: 4.19},
                Regular: {cal: 760, price: 5.19},
                Large: {cal: 1208, price: 7.49}
            })">+</button>
            </div>
        </div>
    </div>

    <!-- Strawberry Shake -->
    <div class="product-card">
        <img src="./Assets/strawberry_shake.jpg" alt="" />
        <div class="product-info">
            <h3>Strawberry Shake</h3>
            <div>
                <span>$3.69-$7.49</span>
                <span>610-1208 cal</span>
                <button type="button" onclick="showShakeModal('Strawberry Shake', {
                Small: {cal: 610, price: 4.19},
                Regular: {cal: 760, price: 5.19},
                Large: {cal: 1208, price: 7.49}
            })">+</button>
            </div>
        </div>
    </div>

    <!-- Vanilla Shake -->
    <div class="product-card">
        <img src="./Assets/vanilla_shake.jpg" alt="" />
        <div class="product-info">
            <h3>Vanilla Shake</h3>
            <div>
                <span>$3.69-$7.49</span>
                <span>590-1168 cal</span>
                <button type="button" onclick="showShakeModal('Vanilla Shake', {
                Small: {cal: 590, price: 4.19},
                Regular: {cal: 740, price: 5.19},
                Large: {cal: 1168, price: 7.49}
            })">+</button>
            </div>
        </div>
    </div>


</div>

    <div class="title-bold">YOUR MEAL</div>
    <div style="background:white; padding:15px; border-radius:8px; max-width:400px; margin-bottom: 200px;">
        <ul id="cartList" style="list-style-type:none; padding-left:0;"></ul>
        <p id="totalCalories"><strong>Total Calories: 0</strong></p>
        <p id="totalPrice"><strong>Total Price: $0.00</strong></p>
    </div>

<div id="spiceModal" style="display:none;" class="modal-overlay">
    <div class="modal-content">
        <h3>Select Spice Level</h3>
        <p id="mealNameDisplay"></p>

        <button type="button" class="spice-option" onclick="selectSpice('Low')">No Spice / Light Mild</button>
        <button type="button" class="spice-option" onclick="selectSpice('High')">Mild to Reaper</button>

        <br /><br />
        <button type="button" onclick="closeModal()">Cancel</button>

    </div>
</div>

<div id="shakeModal" style="display:none;" class="modal-overlay">
    <div class="modal-content">
        <h3>Select Shake Size</h3>
        <p id="shakeNameDisplay"></p>

        <button type="button" class="spice-option" onclick="selectShakeSize('Small')">
            Small
        </button>
        <button type="button" class="spice-option" onclick="selectShakeSize('Regular')">
            Regular
        </button>
        <button type="button" class="spice-option" onclick="selectShakeSize('Large')">
            Large
        </button>

        <br /><br />
        <button type="button" onclick="closeShakeModal()">Cancel</button>
    </div>
</div>


</asp:Content>
