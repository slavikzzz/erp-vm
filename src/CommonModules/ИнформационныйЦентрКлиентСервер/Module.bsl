#Область СлужебныйПрограммныйИнтерфейс

#Область ШифрованиеКодаПользователя_СлужебныйПрограммныйИнтерфейс
// Методы области ШифрованиеКодаПользователя_СлужебныйПрограммныйИнтерфейс заимствованы 
// из подсистемы ИнтеграцияС1СДокументооборотом из конфигурации УправлениеПредприятием (1С:ERP)

// Разделяет код пользователя на две независимые части для последующего восстановления функцией СобратьКодПользователя.
//
// Параметры:
//   КодПользователя - Строка - разделяемый код пользователя.
//
// Возвращаемое значение:
//   Массив из Строка - массив из двух строк, содержащих шестнадцатиричное представление кода пользователя.
//
Функция РазделитьКодПользователя(КодПользователя) Экспорт
	
	Результат = Новый Массив;
	Результат.Добавить("");
	Результат.Добавить("");
	Генератор = Неопределено;
	
	// Разложим код в массив чисел попарно.
	МассивЧисел = Новый Массив;
	Индекс = 1;
	Пока Индекс <= СтрДлина(КодПользователя) Цикл
		Число = КодСимвола(КодПользователя, Индекс);
		Индекс = Индекс + 1;
		Если Индекс <= СтрДлина(КодПользователя) Тогда
			Число = Число * 65536 + КодСимвола(КодПользователя, Индекс);
			Индекс = Индекс + 1;
		КонецЕсли;
		МассивЧисел.Добавить(Число);
	КонецЦикла;
	
	// Разделим каждое из полученных чисел.
	Для каждого Число из МассивЧисел Цикл
		РазделенноеЧисло = РазделитьЧисло(Число, Генератор); // ((1, NNN), (2, MMM))
		Результат[0] = Результат[0] + ШестнадцатиричноеПредставлениеЧисла(РазделенноеЧисло[0][1], 8);
		Результат[1] = Результат[1] + ШестнадцатиричноеПредставлениеЧисла(РазделенноеЧисло[1][1], 8);
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

// Собирает код пользователя из двух частей, ранее разделенных функцией РазделитьКодПользователя.
// В случае повреждения строк возвращает Неопределено.
//
// Параметры:
//   РазделенныйКод - Массив - две строки, содержащие разделенный код пользователя.
//
// Возвращаемое значение:
//   Строка - собранный код пользователя или
//   Неопределено - если строки повреждены.
//
Функция СобратьКодПользователя(Знач РазделенныйКод) Экспорт
	
	Если РазделенныйКод.Количество() <> 2 Тогда
		Возврат Неопределено;
	КонецЕсли;
	РазделенныйКод[0] = СокрЛП(РазделенныйКод[0]);
	РазделенныйКод[1] = СокрЛП(РазделенныйКод[1]);
	Если СтрДлина(РазделенныйКод[0]) <> СтрДлина(РазделенныйКод[1]) Тогда
		Возврат Неопределено;
	КонецЕсли;
	Если СтрДлина(РазделенныйКод[0]) % 8 <> 0 Тогда
		Возврат Неопределено;
	КонецЕсли;
	Результат = "";
	Чисел = Цел(СтрДлина(РазделенныйКод[0])) / 8;
	Для НЧисла = 1 по Чисел Цикл
		РазделенноеЧисло = Новый Массив;
		Для НЧасти = 0 по 1 Цикл
			Пара = Новый Массив;
			Пара.Добавить(НЧасти + 1);
			Представление = Сред(РазделенныйКод[НЧасти], 1 + (НЧисла - 1) * 8, 8);
			Пара.Добавить(ЧислоИзШестнадцатиричногоПредставления(Представление));
			РазделенноеЧисло.Добавить(Пара);
		КонецЦикла;
		СобранноеЧисло = СобратьЧисло(РазделенноеЧисло);
		Если СобранноеЧисло >= 65536 Тогда
			Результат = Результат + Символ(Цел(СобранноеЧисло / 65536));
		КонецЕсли;
		Результат = Результат + Символ(СобранноеЧисло % 65536);
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ШифрованиеКодаПользователя_СлужебныеПроцедурыИФункции
// Методы области ШифрованиеКодаПользователя_СлужебныеПроцедурыИФункции заимствованы 
// из подсистемы ИнтеграцияС1СДокументооборотом из конфигурации УправлениеПредприятием (1С:ERP)

// Возвращает шестнадцатиричное представление числа.
//
// Параметры:
//   Число - Число - целое число.
//   Разрядов - Число - минимальная ширина результата.
//            - Неопределено - не дополнять нулями.
//
// Возвращаемое значение:
//   Строка - шестнадцатиричное представление числа, возможно,
//   дополненное нулями до указанного количества разрядов.
//
Функция ШестнадцатиричноеПредставлениеЧисла(Знач Число, Разрядов = Неопределено)
	
	Если Число = 0 и Разрядов = Неопределено Тогда
		Возврат "0";
	КонецЕсли;
	
	Результат = "";
	НРазряда = 0;
	Пока Истина Цикл
		НРазряда = НРазряда + 1;
		Если Число = 0 Тогда // возможно, следует дополнить до указанного числа разрядов
			Если Разрядов = Неопределено Тогда
				Прервать;
			ИначеЕсли НРазряда > Разрядов Тогда
				Прервать;
			КонецЕсли;
		КонецЕсли;
		ПравыйРазряд = Число % 16;
		Число = Цел(Число / 16);
		Если ПравыйРазряд > 9 Тогда
			Результат = Символ(КодСимвола("A") + ПравыйРазряд - 10) + Результат;
		Иначе
			Результат = Символ(КодСимвола("0") + ПравыйРазряд) + Результат;
		КонецЕсли;
	КонецЦикла;
	Возврат Результат;
	
КонецФункции

// Собирает число, разделенное по алгоритму Шамира на части функцией РазделитьЧисло.
//
// Параметры:
//   РазделенноеЧисло - Массив - массив пар чисел вида (1, 123), (2, 234), ...
//
// Возвращаемое значение:
//   Число - исходное число.
//
Функция СобратьЧисло(РазделенноеЧисло)
	
	Результат = 0;
	Модуль = МодульКольцаВычетов();
	Для Строка = 0 по РазделенноеЧисло.Количество() - 1 Цикл
		Нумератор = 1; 
		Делитель = 1;
		Для Колонка = 0 по РазделенноеЧисло.Количество() - 1 Цикл
			Если Строка = Колонка Тогда
				Продолжить;
			КонецЕсли;
			От = РазделенноеЧисло[Строка][0];
			До  = РазделенноеЧисло[Колонка][0];
			Нумератор = (Нумератор * -До) % Модуль;
			Делитель = (Делитель * (От - До)) % Модуль;
		КонецЦикла;
		Значение = РазделенноеЧисло[Строка][1];
		Результат = (Модуль + Результат + (Значение * Нумератор * ОбратныйМодуль(Делитель))) % Модуль;
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

// Рассчитывает обратный модуль.
//
// Параметры:
//   ЧислоK - Число.
//
// Возвращаемое значение:
//   Число - такое, что (ЧислоK * ОбратныйМодуль(ЧислоK)) % Модуль = 1 для всех 
//   положительных ЧислоK < Модуль.
//
Функция ОбратныйМодуль(Знач ЧислоK)
	
	Модуль = МодульКольцаВычетов();
	ЧислоK = ЧислоK % Модуль;
	
	Если ЧислоK < 0 Тогда
		Разложение = РазложитьНОД(Модуль, -ЧислоK);
		МножительРазложения = -Разложение[2];
	Иначе
		Разложение = РазложитьНОД(Модуль, ЧислоK);
		МножительРазложения = Разложение[2];
	КонецЕсли;
	
	Возврат (Модуль + МножительРазложения) % Модуль;
	
КонецФункции

// Выполняет разложение наибольшего общего делителя пары чисел A и B.
//
// Параметры:
//   ЧислоA - Число.
//   ЧислоB - Число.
//
// Возвращаемое значение:
//   Массив - (X, Y, Z), такой, что:
//     X - наибольший общий делитель ЧислоA и ЧислоB;
//     X = ЧислоA * Y + ЧислоB * Z.
//
Функция РазложитьНОД(Знач ЧислоA, Знач ЧислоB)
	
	Результат = Новый Массив;
	
	Если ЧислоB = 0 Тогда
		Результат.Добавить(ЧислоA);
		Результат.Добавить(1);
		Результат.Добавить(0);
	Иначе
		Частное = Цел(ЧислоA / ЧислоB);
		Модуль = ЧислоA % ЧислоB;
		Разложение = РазложитьНОД(ЧислоB, Модуль);
		Результат.Добавить(Разложение[0]);
		Результат.Добавить(Разложение[2]);
		Результат.Добавить(Разложение[1] - Разложение[2] * Частное);
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

// Возвращает большое простое число, используемое как модуль кольца классов вычетов.
// Должно быть больше любого из кодируемых чисел.
//
Функция МодульКольцаВычетов()
	Возврат 4294967291; // больше любого из вероятных сочетаний двух символов пароля.
КонецФункции

// Получает число из его шестнадцатиричного представления. Может вызывать исключение.
//
// Параметры:
//   Представление - Строка - шестнадцатиричное число.
//
// Возвращаемое значение:
//   Число - преобразованное число.
//
Функция ЧислоИзШестнадцатиричногоПредставления(Знач Представление)
	
	Если Представление = "" Тогда
		Возврат 0;
	КонецЕсли;
	Представление = ВРег(Представление);
	
	Результат = 0;
	Пока Представление <> "" Цикл
		Разряд = Лев(Представление, 1);
		Представление = Сред(Представление, 2);
		Если Разряд >= "0" и Разряд <= "9" Тогда
			Результат = Результат * 16 + КодСимвола(Разряд, 1) - КодСимвола("0");
		ИначеЕсли Разряд >= "A" и Разряд <= "F" Тогда
			Результат = Результат * 16 + 10 + КодСимвола(Разряд, 1) - КодСимвола("A");
		Иначе
			ВызватьИсключение НСтр("ru = 'Ошибочный символ в шестнадцатиричной строке.';
									|en = 'Wrong character in a hexadecimal string.'");
		КонецЕсли;
	КонецЦикла;
	Возврат Результат;
	
КонецФункции

// Разделяет число-секрет на указанное количество частей по алгоритму Шамира.
//
// Параметры:
//   Число - Число - разделяемое число, от 0 до 2^32 - 1.
//   Генератор - ГенераторСлучайныхЧисел - генератор случайных чисел, желательно сохранять его между вызовами.
//   Частей - Число - количество частей, на которые разделяется число.
//   Обязательных - Число - количество частей, требуемых для восстановления.
//
// Возвращаемое значение:
//   Массив - массив пар чисел вида (1, 123), (2, 234), (3, 345), необходимых для восстановления.
//
Функция РазделитьЧисло(Число, Генератор = Неопределено, Частей = 2, Обязательных = 2)
	
	#Если Не ВебКлиент Тогда
		
	Если Генератор = Неопределено Тогда
		Генератор = Новый ГенераторСлучайныхЧисел(ТекущаяДата() - Дата(1, 1, 1)); // Использование оправдано: ГСЧ.
	КонецЕсли;
	Модуль = МодульКольцаВычетов();
	
	Пока Истина Цикл
		Результат = Новый Массив;
		Коэффициенты = Новый Массив;
		Коэффициенты.Добавить(Число);
		Коэффициенты.Добавить(Цел(Генератор.СлучайноеЧисло(0, Модуль - 1)));
		Коэффициенты.Добавить(Цел(Генератор.СлучайноеЧисло(0, Модуль - 1)));
		Для Часть = 1 по Частей Цикл
			Значение = Число;
			Для Степень = 1 по Обязательных - 1 Цикл
				Значение = (
					Значение + (Коэффициенты[Степень] * (Pow(Часть, Степень) % Модуль)) % Модуль
				) % Модуль;
			КонецЦикла;
			Пара = Новый Массив;
			Пара.Добавить(Часть);
			Пара.Добавить(Значение);
			Результат.Добавить(Пара);
		КонецЦикла;
		Если СобратьЧисло(Результат) = Число Тогда
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Результат;
	
	#Иначе
		
	ВызватьИсключение НСтр("ru = 'Функция не поддерживается в веб-клиенте.';
							|en = 'Function is not supported in web client.'")
	
	#КонецЕсли
	
КонецФункции

#КонецОбласти

#КонецОбласти
