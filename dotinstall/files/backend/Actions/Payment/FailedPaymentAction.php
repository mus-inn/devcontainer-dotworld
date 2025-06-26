<?php

namespace App\Actions\Payment;

use Musine\MusineClientApi\Contracts\Actions\FailedPaiementActionContract;

class FailedPaymentAction implements FailedPaiementActionContract
{
    public function handle(string $idClientUnique, string $email, string $name): \Illuminate\Http\RedirectResponse|\Illuminate\Routing\Redirector
    {
        return redirect()->to('/');
    }
}