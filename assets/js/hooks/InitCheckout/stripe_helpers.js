let stripe, card;

export const setupStripe = (form, paymentMethodCreatedCallback, isLoading) => {
  stripe = Stripe(form.dataset.publicKey);
  const elements = stripe.elements();
  card = elements.create("card", { style: cardStyle });

  card.mount("#card-element");
  card.on("change", displayError);
  card.on("focus", displayError);

  form.addEventListener("submit", (event) => {
    event.preventDefault();
    isLoading(true);
    createPaymentMethod(paymentMethodCreatedCallback, isLoading);
  });
};

const createPaymentMethod = (paymentMethodCreatedCallback, isLoading) => {
  const billingName = document.querySelector("#card-name").value;
  stripe
    .createPaymentMethod({
      type: "card",
      card: card,
      billing_details: { name: billingName },
    })
    .then((result) => {
      isLoading(false);
      if (result.error) {
        displayError(result);
      } else {
        paymentMethodCreatedCallback(result.paymentMethod);
      }
    });
};

export const handleCustomerAction = (
  { clientSecret, paymentMethodId },
  isLoading
) => {
  stripe
    .confirmCardPayment(clientSecret, { payment_method: paymentMethodId })
    .then((result) => {
      isLoading(false);
      if (result.error) {
        displayError(result);
      }
    });
};

export const displayError = (event) => {
  const errorElement = document.getElementById("card-errors");
  errorElement.textContent = event.error ? event.error.message : "";
};

const cardStyle = {
  base: {
    color: "#32325d",
    fontFamily: '"Helvetica Neue", Helvetica, sans-serif',
    fontSmoothing: "antialiased",
    fontSize: "16px",
    "::placeholder": {
      color: "#aab7c4",
    },
  },
  invalid: {
    color: "#fa755a",
    iconColor: "#fa755a",
  },
};
