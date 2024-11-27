<?php

namespace App\Actions\Payment;

use Musine\MusineClientApi\Contracts\Actions\WaitingPaiementActionContract;

class WaitingPaymentAction implements WaitingPaiementActionContract
{
    public function handle(string $idClientUnique, string $email, string $name): \Illuminate\Http\RedirectResponse|\Illuminate\Routing\Redirector
    {
        return redirect()->to('/');
    }
}