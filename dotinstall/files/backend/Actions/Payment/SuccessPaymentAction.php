<?php

namespace App\Actions\Payment;

use Musine\MusineClientApi\Contracts\Actions\SuccessPaiementActionContract;

class SuccessPaymentAction implements SuccessPaiementActionContract
{
    public function handle(string $idClientUnique, string $email, string $name): \Illuminate\Http\RedirectResponse|\Illuminate\Routing\Redirector
    {
        

        return redirect()->to('/');
    }
}