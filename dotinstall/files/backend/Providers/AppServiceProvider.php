<?php

namespace App\Providers;

use Illuminate\Support\ServiceProvider;
use Musine\MusineClientApi\Contracts\Actions\FailedPaiementActionContract;
use Musine\MusineClientApi\Contracts\Actions\SuccessPaiementActionContract;
use Musine\MusineClientApi\Contracts\Actions\WaitingPaiementActionContract;
use App\Actions\Payment\SuccessPaymentAction;
use App\Actions\Payment\FailedPaymentAction;
use App\Actions\Payment\WaitingPaymentAction;


class AppServiceProvider extends ServiceProvider
{
    /**
     * Register any application services.
     */
    public function register(): void
    {
        $this->app->bind(SuccessPaiementActionContract::class, SuccessPaymentAction::class);
        $this->app->bind(FailedPaiementActionContract::class, FailedPaymentAction::class);
        $this->app->bind(WaitingPaiementActionContract::class, WaitingPaymentAction::class);
    }

    /**
     * Bootstrap any application services.
     */
    public function boot(): void
    {
    }
}