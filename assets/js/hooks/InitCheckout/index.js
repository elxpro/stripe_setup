import { setupStripe, handleCustomerAction } from "./stripe_helpers";

const InitCheckout = {
  mounted() {
    const paymentMethodCreatedCallback = (paymentMethod) => {
      this.pushEvent("payment_method_created", { paymentMethod });
    };

    const isLoading = (loadingState) => {
      this.pushEvent("is_loading", { loading: loadingState });
    };

    setupStripe(this.el, paymentMethodCreatedCallback, isLoading);

    this.handleEvent("requires_action", (data) => {
      handleCustomerAction(data, isLoading);
    });
  },
};

export default InitCheckout;
