# SmartContract
Smart contract draft
Проверка смарт-контракта через Remix IDE
Шаг 1: Открытие Remix IDE
1. Перейдите на сайт [Remix IDE](https://remix.ethereum.org/).
2. Убедитесь, что в браузере включён MetaMask для тестовых сетей (если нужно тестировать в реальной сети).
Шаг 2: Создание файла
1. В левой панели Remix нажмите на иконку файловой системы.
2. Нажмите "Create New File" и назовите файл Escrow.sol.
3. Вставьте в файл код из SmartContract:
Шаг 3: Компиляция контракта
1. В левой панели выберите вкладку "Solidity Compiler" (иконка с молотком).
2. Убедитесь, что версия компилятора соответствует версии в коде (^0.8.0).
3. Нажмите "Compile Escrow.sol".
   - Если компиляция завершилась успешно, внизу появится зелёная галочка.
Шаг 4: Деплой контракта
1. Перейдите во вкладку "Deploy & Run Transactions" (иконка с кнопкой "play").
2. Настройки:
   - Выберите Environment → Remix VM (London) для тестирования на локальном блокчейне.
   - Убедитесь, что поле Value заполнено (например, 1 ether), чтобы внести средства в контракт.
3. В разделе Deploy укажите:
   - _payee: адрес получателя средств.
   - _arbiter: адрес арбитра.
4. Нажмите "Deploy".
   - Контракт появится в нижней части панели.
Шаг 5: Проверка контракта
1. После деплоя нажмите на треугольник рядом с именем контракта, чтобы развернуть его.
2. Проверьте значения переменных:
   - payer: адрес, который создал контракт.
   - payee: указанный адрес получателя.
   - arbiter: указанный адрес арбитра.
   - amount: внесённая сумма.
3. Вызов функций:
   - releaseFunds(): Выпуск средств. Вызвать может только арбитр. После этого средства будут отправлены на адрес получателя.
   - refund(): Возврат средств. Вызвать может только арбитр. После этого средства вернутся плательщику.
Шаг 6: Тестовые кейсы
1. Сценарий 1: Успешный выпуск средств
   - Вызывайте releaseFunds() от имени арбитра.
   - Проверьте, что адрес получателя получил средства, а баланс контракта стал равен 0.
2. Сценарий 2: Возврат средств
   - Вызывайте refund() от имени арбитра.
   - Проверьте, что адрес плательщика получил средства обратно.
3. Сценарий 3: Ограничения доступа
   - Попробуйте вызвать releaseFunds() или refund() от имени другого адреса (не арбитра).
   - Контракт должен выдать ошибку.
Шаг 7: Дополнительные проверки
- Попробуйте развернуть контракт с разными значениями и проверить, правильно ли он обрабатывает логику.
- Просмотрите журнал событий (Logs) в нижней части Remix после вызова функций.
