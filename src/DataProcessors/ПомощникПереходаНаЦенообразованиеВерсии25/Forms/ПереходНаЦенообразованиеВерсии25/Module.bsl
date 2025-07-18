
#Область ОписаниеПеременных

&НаКлиенте
Перем ЗакрытьБезусловно;

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ОбновлениеСтатусаПереходаНаСервере();
		
	Если Состояние <> Перечисления.СостоянияЗаданий.Выполняется Тогда
		
		ДатаПереходаНаЦенообразование25 = ЦенообразованиеВызовСервера.ДатаПереходаНаЦенообразованиеВерсии25();
		Если НЕ ЗначениеЗаполнено(ДатаПереходаНаЦенообразование25) Тогда
			ДатаПереходаНаЦенообразование25 = НачалоДня(ТекущаяДатаСеанса() + 86400);
		КонецЕсли;
		
	КонецЕсли;
	
	ИспользоватьХарактеристикиНоменклатуры = ПолучитьФункциональнуюОпцию("ИспользоватьХарактеристикиНоменклатуры");
	ИспользоватьСерииНоменклатуры          = ПолучитьФункциональнуюОпцию("ИспользоватьСерииНоменклатуры");
	ИспользоватьУпаковкиНоменклатуры       = ПолучитьФункциональнуюОпцию("ИспользоватьУпаковкиНоменклатуры");
	
	НастроитьФорму();
	
	УстановитьУсловноеОформление();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ПриОткрытииФормы();
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если ЗавершениеРаботы Или ЗначениеЗаполнено(ДатаНачала) Или ЗакрытьБезусловно = Истина Тогда
		Возврат;
	КонецЕсли;
	
	Отказ = Истина;
	СтандартнаяОбработка = Ложь;
	ОписаниеОповещения = Новый ОписаниеОповещения("ПередЗакрытиемОповещение", ЭтотОбъект);
	ТекстВопроса = НСтр("ru = 'Закрыть помощник?';
						|en = 'Close the wizard?'");
	ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНет, , КодВозвратаДиалога.Нет);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Далее(Команда)

	Если Элементы.Страницы.ТекущаяСтраница = Элементы.СтраницаНачальная Тогда
		НоваяСтраница = СтраницаНачальнаяДалее();
	ИначеЕсли Элементы.Страницы.ТекущаяСтраница = Элементы.СтраницаВыбораВидовЦен Тогда
		НоваяСтраница = СтраницаВыбораВидовЦенДалее();
	ИначеЕсли Элементы.Страницы.ТекущаяСтраница = Элементы.СтраницаНастройкиВидовНоменклатуры Тогда
		НоваяСтраница = СтраницаНастройкиВидовНоменклатурыДалее();
	ИначеЕсли Элементы.Страницы.ТекущаяСтраница = Элементы.СтраницаЗапускаАвтоматическогоПерехода Тогда
		НоваяСтраница = СтраницаЗапускаАвтоматическогоПереходаДалее();
	ИначеЕсли Элементы.Страницы.ТекущаяСтраница = Элементы.СтраницаОжидание Тогда
		НоваяСтраница = СтраницаОжиданиеДалее();
	ИначеЕсли Элементы.Страницы.ТекущаяСтраница = Элементы.СтраницаРезультат Тогда
		НоваяСтраница = СтраницаРезультатДалее();
	ИначеЕсли Элементы.Страницы.ТекущаяСтраница = Элементы.СтраницаОшибка Тогда
		НоваяСтраница = СтраницаОшибкаДалее();
	ИначеЕсли Элементы.Страницы.ТекущаяСтраница = Элементы.СтраницаВозвратаНаСтароеЦенообразование Тогда
		НоваяСтраница = СтраницаВозвратаНаСтароеЦенообразованиеДалее();
	КонецЕсли;
	
	Если НоваяСтраница <> Неопределено Тогда
		ОткрытиеСтраницы(НоваяСтраница);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	
	Если Элементы.Страницы.ТекущаяСтраница = Элементы.СтраницаРезультат Тогда
	
		ОткрытиеСтраницы(Элементы.СтраницаВозвратаНаСтароеЦенообразование);
		
	ИначеЕсли Элементы.Страницы.ТекущаяСтраница = Элементы.СтраницаВозвратаНаСтароеЦенообразование Тогда
		
		Закрыть();
		
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура Назад(Команда)
	
	Если Элементы.Страницы.ТекущаяСтраница = Элементы.СтраницаВыбораВидовЦен Тогда
		Страница = Элементы.СтраницаНачальная;
	ИначеЕсли Элементы.Страницы.ТекущаяСтраница = Элементы.СтраницаНастройкиВидовНоменклатуры Тогда
		Страница = Элементы.СтраницаВыбораВидовЦен;
	ИначеЕсли Элементы.Страницы.ТекущаяСтраница = Элементы.СтраницаЗапускаАвтоматическогоПерехода Тогда
		Страница = Элементы.СтраницаНастройкиВидовНоменклатуры;
	КонецЕсли;
	
	Если Страница <> Неопределено Тогда
		ОткрытиеСтраницы(Страница, Истина);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтображатьТолькоВыбранные(Команда)
	
	ДеревоВыбранныеЦеныОтображатьТолькоВыбранные = НЕ ДеревоВыбранныеЦеныОтображатьТолькоВыбранные;
	ЗаполнитьДеревоВидовЦен();	
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьВсеВидыЦен(Команда)
	ИзменитьФлагВыбранВДеревеВидовЦенСервер(Истина);
КонецПроцедуры

&НаКлиенте
Процедура ИсключитьВсеВидыЦен(Команда)
	ИзменитьФлагВыбранВДеревеВидовЦенСервер(Ложь);
КонецПроцедуры

&НаСервере
Процедура ИзменитьФлагВыбранВДеревеВидовЦенСервер(ФлагВыбран)
	
	Дерево = РеквизитФормыВЗначение("ДеревоВыбранныеЦены", Тип("ДеревоЗначений"));	
	ИзменитьФлагВыбранВДеревеВидовЦен(Дерево.Строки, ФлагВыбран);
	ЗначениеВДанныеФормы(Дерево, ДеревоВыбранныеЦены);
	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоВыбранныеЦеныСсылкаОчистка(Элемент, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
КонецПроцедуры

&НаКлиенте
Процедура ДеревоВыбранныеЦеныСсылкаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
КонецПроцедуры

&НаКлиенте
Процедура ДеревоВыбранныеЦеныВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
		
	СтандартнаяОбработка = Ложь;
	
	ТекущиеДанные = Элемент.ТекущиеДанные;
	
	Если ТекущиеДанные <> Неопределено Тогда
		Если НЕ ТекущиеДанные.ЭтоГруппа Тогда
			Если Поле = Элементы.ДеревоВыбранныеЦеныВлияющиеЦены Тогда
				Если ТекущиеДанные.ВлияющиеЦены.Количество() > 0 Тогда
					ПоказатьЗначение(Неопределено, ТекущиеДанные.ВлияющиеЦены);
				КонецЕсли;
			ИначеЕсли Поле = Элементы.ДеревоВыбранныеЦеныЗависимыеЦены Тогда	
					Если ТекущиеДанные.ЗависимыеЦены.Количество() > 0 Тогда
						ПоказатьЗначение(Неопределено, ТекущиеДанные.ЗависимыеЦены);
					КонецЕсли;
			Иначе
				ПоказатьЗначение(Неопределено, ТекущиеДанные.Ссылка);
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоВыбранныеЦеныПередУдалением(Элемент, Отказ)
	Отказ = Истина;
КонецПроцедуры


&НаКлиенте
Процедура ДеревоВыбранныеЦеныВыборЗначения(Элемент, Значение, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ОбработчикиСтраниц

&НаКлиенте
Процедура ОткрытиеСтраницы(Страница, ЭтоПереходНазад = Ложь)
	
	Элементы.Далее.Видимость = Истина;
	Элементы.Далее.Доступность = Истина;
	Элементы.Далее.Заголовок = НСтр("ru = 'Далее >>';
									|en = 'Next >>'");
	
	Элементы.Отмена.Видимость = Ложь;
	Элементы.Отмена.Заголовок = НСтр("ru = 'Отмена';
									|en = 'Cancel'");
	
	ИзменитьПодсказку("Далее", НСтр("ru = 'Далее';
									|en = 'Next'"));
	ИзменитьПодсказку("Отмена", НСтр("ru = 'Отмена';
									|en = 'Cancel'"));
	
	Элементы.Назад.Видимость = Истина;
	
	Если Страница = Элементы.СтраницаНачальная Тогда
		СтраницаНачальнаяОткрытие(ЭтоПереходНазад);
	ИначеЕсли Страница = Элементы.СтраницаВыбораВидовЦен Тогда
		СтраницаВыбораВидовЦенОткрытие(ЭтоПереходНазад);
	ИначеЕсли Страница = Элементы.СтраницаНастройкиВидовНоменклатуры Тогда
		СтраницаНастройкиВидовНоменклатурыОткрытие(ЭтоПереходНазад);
	ИначеЕсли Страница = Элементы.СтраницаЗапускаАвтоматическогоПерехода Тогда
		СтраницаЗапускаАвтоматическогоПереходаОткрытие(ЭтоПереходНазад);
	ИначеЕсли Страница = Элементы.СтраницаОжидание Тогда
		СтраницаОжиданиеОткрытие(ЭтоПереходНазад);
	ИначеЕсли Страница = Элементы.СтраницаОшибка Тогда
		СтраницаОшибкаОткрытие(ЭтоПереходНазад);
	ИначеЕсли Страница = Элементы.СтраницаРезультат Тогда
		СтраницаРезультатОткрытие(ЭтоПереходНазад);
	ИначеЕсли Страница = Элементы.СтраницаВозвратаНаСтароеЦенообразование Тогда
		СтраницаВозвратаНаСтароеЦенообразованиеОткрытие(ЭтоПереходНазад);
	КонецЕсли;
	
	Элементы.Страницы.ТекущаяСтраница = Страница;
	
КонецПроцедуры

&НаКлиенте
Процедура СтраницаНачальнаяОткрытие(ЭтоПереходНазад)
	
	Заголовок = НСтр("ru = 'Шаг 1. Переход на ценообразование 11.5';
					|en = 'Step 1. Migration to pricing 11.5'");
	//++ НЕ УТ
	СкорректироватьВерсиюЦенообразования(Заголовок);
	//-- НЕ УТ

	Элементы.Назад.Видимость = Ложь;
	
КонецПроцедуры

&НаКлиенте
Функция СтраницаНачальнаяДалее()
	
	Возврат Элементы.СтраницаВыбораВидовЦен;
	
КонецФункции

&НаКлиенте
Процедура СтраницаВыбораВидовЦенОткрытие(ЭтоПереходНазад)
	
	Заголовок = НСтр("ru = 'Шаг 2. Выбор видов цен для автоматического переноса';
					|en = 'Step 2. Select price types for automatic transfer'");

	Если Не ЭтоПереходНазад Тогда
		ЗаполнитьДеревоВидовЦен();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Функция СтраницаВыбораВидовЦенДалее()
	
	Возврат Элементы.СтраницаНастройкиВидовНоменклатуры;
	
КонецФункции

&НаКлиенте
Процедура СтраницаНастройкиВидовНоменклатурыОткрытие(ЭтоПереходНазад)
	
	Заголовок = НСтр("ru = 'Шаг 3. Настройка разрезов ценообразования в видах номенклатуры';
					|en = 'Step 3. Set up pricing dimensions in item kinds'");
	
КонецПроцедуры

&НаКлиенте
Функция СтраницаНастройкиВидовНоменклатурыДалее()
	
	Возврат Элементы.СтраницаЗапускаАвтоматическогоПерехода;
	
КонецФункции

&НаКлиенте
Процедура СтраницаЗапускаАвтоматическогоПереходаОткрытие(ЭтоПереходНазад)
	
	Заголовок = НСтр("ru = 'Шаг 4. Запуск автоматического перехода';
					|en = 'Step 4. Starting automatic migration'");
	
	Элементы.Далее.Заголовок = НСтр("ru = 'Перейти на новое ценообразование >>';
									|en = 'Migrate to new pricing >>'");
	ИзменитьПодсказку("Далее", НСтр("ru = 'Перейти на новое ценообразование';
									|en = 'Migrate to new pricing'"));
	
КонецПроцедуры

&НаКлиенте
Функция СтраницаЗапускаАвтоматическогоПереходаДалее()

	НачатьПереходНаЦенообразованиеВерсии2_5();
	
	Возврат Элементы.СтраницаОжидание;
	
КонецФункции

&НаКлиенте
Процедура СтраницаВозвратаНаСтароеЦенообразованиеОткрытие(ЭтоПереходНазад)
	
	Заголовок = НСтр("ru = 'Возврат на ценообразование версии 11.0';
					|en = 'Return to pricing version 11.0'");
	//++ НЕ УТ
	СкорректироватьВерсиюЦенообразования(Заголовок);
	//-- НЕ УТ
	Элементы.Отмена.Видимость = Истина;
	Элементы.Назад.Видимость = Ложь;
	
	Элементы.Далее.Заголовок = НСтр("ru = 'Вернуться на ценообразование версии 11.0';
									|en = 'Return to pricing version 11.0'");
	//++ НЕ УТ
	СкорректироватьВерсиюЦенообразования(Элементы.Далее.Заголовок);
	//-- НЕ УТ

	ИзменитьПодсказку("Далее", НСтр("ru = 'Вернуться на ценообразование версии 11.0';
									|en = 'Return to pricing version 11.0'"));
	
КонецПроцедуры

&НаКлиенте
Функция СтраницаВозвратаНаСтароеЦенообразованиеДалее()

	врУстановитьЗначениеКонст();
	Оповестить("Запись_НаборКонстант", Новый Структура, "ИспользуетсяЦенообразование25");
	
	Возврат Элементы.СтраницаРезультат;
	
КонецФункции

&НаСервереБезКонтекста
Процедура врУстановитьЗначениеКонст(Значение = Ложь, ДатаПереходаНаЦенообразование25 = Неопределено)
	
	НачатьТранзакцию();
	Попытка
		
		Константы.ИспользуетсяЦенообразование25.Установить(Значение);
		
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
	КонецПопытки;
КонецПроцедуры

&НаКлиенте
Функция СтраницаОжиданиеДалее()
	
	Закрыть();
	
	Возврат Неопределено;
	
КонецФункции

&НаКлиенте
Процедура СтраницаОжиданиеОткрытие(ЭтоПереходНазад)

	Заголовок = НСтр("ru = 'Шаг 5. Выполняется переход на ценообразование версии 11.5 ...';
					|en = 'Step 5. Migrating to pricing version 11.5 ...'");
	//++ НЕ УТ
	СкорректироватьВерсиюЦенообразования(Заголовок);
	//-- НЕ УТ
	
	Элементы.Далее.Видимость = Истина;;
	Элементы.Далее.Заголовок = НСтр("ru = 'Закрыть мастер';
									|en = 'Close wizard'");
	Элементы.Назад.Видимость = Ложь;
	
	ИзменитьПодсказку("Далее", НСтр("ru = 'Закрыть мастер';
									|en = 'Close wizard'"));
	
	ПодключитьОбработчикОжидания("ОбновлениеСтатусаПерехода", 1, Ложь);
	
КонецПроцедуры

&НаКлиенте
Функция СтраницаРезультатДалее()
	
	Закрыть();
	Возврат Неопределено;
	
КонецФункции

&НаКлиенте
Процедура СтраницаРезультатОткрытие(ЭтоПереходНазад)
	
	Заголовок = НСтр("ru = 'Результат перехода';
					|en = 'Migration result'");
	
	Элементы.Далее.Заголовок = НСтр("ru = 'Готово';
									|en = 'Done'");
	Элементы.Отмена.Заголовок = НСтр("ru = 'Вернуться на версию 11.0';
									|en = 'Return to version 11.0'");
	//++ НЕ УТ
	СкорректироватьВерсиюЦенообразования(Элементы.Отмена.Заголовок);
	//-- НЕ УТ
	
	ИзменитьПодсказку("Далее", НСтр("ru = 'Готово';
									|en = 'Done'"));
	ИзменитьПодсказку("Отмена", НСтр("ru = 'Вернуться на версию 11.0';
									|en = 'Return to version 11.0'"));

	Элементы.Назад.Видимость = Ложь;

	ИспользуетсяЦенообразование25 = ЦенообразованиеВызовСервера.ИспользуетсяЦенообразование25(ДатаПереходаНаЦенообразование25);
	Элементы.Отмена.Видимость = ИспользуетсяЦенообразование25;
	Элементы.ДекорацияРезультат20.Видимость = Не ИспользуетсяЦенообразование25;
	Элементы.ДекорацияРезультат25.Видимость = ИспользуетсяЦенообразование25;

	Элементы.ГруппаСтраницаРезультатИнформация.Видимость = ЕстьОшибкиПриПереносеЦен();

КонецПроцедуры

&НаКлиенте
Функция СтраницаОшибкаДалее()
	
	ОчиститьСостояниеПерехода();
	Закрыть();
	Возврат Неопределено;
	
КонецФункции

&НаКлиенте
Процедура СтраницаОшибкаОткрытие(ЭтоПереходНазад)
	
	Элементы.Далее.Заголовок = НСтр("ru = 'Готово';
									|en = 'Done'");	
	Элементы.Отмена.Видимость = Ложь;
	Элементы.Назад.Видимость = Ложь;
	
	ИзменитьПодсказку("Далее", НСтр("ru = 'Готово';
									|en = 'Done'"));
	
КонецПроцедуры

#КонецОбласти

#Область Прочее

&НаСервере
Процедура ИзменитьПодсказку(ИмяКоманды, Подсказка="")
	Команды[ИмяКоманды].Подсказка = Подсказка;
	//++ НЕ УТ
	СкорректироватьВерсиюЦенообразования(Команды[ИмяКоманды].Подсказка);
	//-- НЕ УТ
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьДеревоВидовЦен()
	Перем Дерево;
	
	Запрос = Новый Запрос();
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ЦеныНоменклатурыСрезПоследних.ВидЦены КАК ВидЦены,
	|	МАКСИМУМ(ЦеныНоменклатурыСрезПоследних.Период) КАК Период
	|ПОМЕСТИТЬ ДатыПоследнихУстановокЦен
	|ИЗ
	|	РегистрСведений.ЦеныНоменклатуры.СрезПоследних КАК ЦеныНоменклатурыСрезПоследних
	|СГРУППИРОВАТЬ ПО
	|	ЦеныНоменклатурыСрезПоследних.ВидЦены
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВидыЦен.Ссылка КАК Ссылка,
	|	ВидыЦен.Родитель КАК Родитель,
	|	ВидыЦен.Наименование КАК Наименование,
	|	ВидыЦен.ЭтоГруппа КАК ЭтоГруппа,
	|	ВидыЦен.ВалютаЦены КАК Валюта,
	|	НЕ ВидыЦен.ЭтоГруппа КАК Выбран,
	|	ВЫБОР
	|		КОГДА ВидыЦен.ЭтоГруппа
	|			ТОГДА 0
	|		ИНАЧЕ 2
	|	КОНЕЦ КАК Картинка,
	|	ВЫБОР
	|		КОГДА ВидыЦен.ЭтоГруппа
	|			ТОГДА ДАТАВРЕМЯ(1, 1, 1, 0, 0, 0)
	|		ИНАЧЕ ЕСТЬNULL(ДатыПоследнихУстановокЦен.Период, ДАТАВРЕМЯ(1, 1, 1, 0, 0, 0))
	|	КОНЕЦ КАК ДатаПоследнейУстановкиЦены,
	|	ВидыЦен.БазовыйВидЦены,
	|	ВидыЦен.ВлияющиеВидыЦен.(
	|		Ссылка,
	|		НомерСтроки,
	|		ВлияющийВидЦен),
	|	ВидыЦен.СпособЗаданияЦены
	|ИЗ
	|	Справочник.ВидыЦен КАК ВидыЦен
	|		ЛЕВОЕ СОЕДИНЕНИЕ ДатыПоследнихУстановокЦен КАК ДатыПоследнихУстановокЦен
	|		ПО ДатыПоследнихУстановокЦен.ВидЦены = ВидыЦен.Ссылка
	|ГДЕ
	|	НЕ ВидыЦен.ПометкаУдаления
	|	И (ВидыЦен.Статус = ЗНАЧЕНИЕ(Перечисление.СтатусыДействияВидовЦен.Действует)
	|	ИЛИ ВидыЦен.Статус ЕСТЬ NULL)";
	
	Дерево = РеквизитФормыВЗначение("ДеревоВыбранныеЦены", Тип("ДеревоЗначений"));

	Если Дерево.Строки.Количество() = 0 Тогда
		МассивВыбранныхСтрок = Неопределено;
	Иначе	
		МассивВыбранныхСтрок = Новый Массив;
		НайтиВыбранныеВИерархии(Дерево.Строки, МассивВыбранныхСтрок);
		
		Если ДеревоВыбранныеЦеныОтображатьТолькоВыбранные Тогда
			Запрос.Параметры.Вставить("МассивВыбранныхСтрок",МассивВыбранныхСтрок);
				Запрос.Текст = Запрос.Текст+"
				|И
		   		|	ВидыЦен.Ссылка В (&МассивВыбранныхСтрок)";
		КонецЕсли;
	КонецЕсли;
	
	Запрос.Текст = Запрос.Текст+"
	|УПОРЯДОЧИТЬ ПО
	|	Ссылка ИЕРАРХИЯ";
	
	Дерево.Строки.Очистить();
	НоваяСтрока = Дерево;
	Результат = Запрос.Выполнить().Выгрузить(ОбходРезультатаЗапроса.ПоГруппировкамСИерархией);
	ПостроитьИерархию(Результат.Строки, НоваяСтрока, Истина, МассивВыбранныхСтрок);
	
	ЗначениеВДанныеФормы(Дерево, ДеревоВыбранныеЦены);
	
КонецПроцедуры

&НаСервере
Процедура ПостроитьИерархию(Строки, СтрокаДерева, ЭтоДеревоЦен = Ложь, МассивВыбранныхСтрок = Неопределено)
	
	Для Каждого СтрокаТЧ Из Строки Цикл
		
		Если ЗначениеЗаполнено(СтрокаТЧ.Родитель) И СтрокаТЧ.Родитель.Ссылка = СтрокаТЧ.Ссылка Тогда
			Продолжить;
		КонецЕсли;
		
		Если Не ЗначениеЗаполнено(СтрокаТЧ.Ссылка) Тогда
			ПостроитьИерархию(СтрокаТЧ.Строки, СтрокаДерева, ЭтоДеревоЦен, МассивВыбранныхСтрок);
			Продолжить;
		КонецЕсли;
		
		НоваяСтрока = СтрокаДерева.Строки.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаТЧ);
		Если МассивВыбранныхСтрок <> Неопределено Тогда
			НоваяСтрока.Выбран = Не МассивВыбранныхСтрок.Найти(СтрокаТЧ.Ссылка) = Неопределено;
		КонецЕсли;
		
		
		Если ЭтоДеревоЦен Тогда
			НоваяСтрока.ВлияющиеЦены.ЗагрузитьЗначения(СтрокаТЧ.ВлияющиеВидыЦен.ВыгрузитьКолонку("ВлияющийВидЦен"));
		КонецЕсли;
		
		ПостроитьИерархию(СтрокаТЧ.Строки, НоваяСтрока, ЭтоДеревоЦен, МассивВыбранныхСтрок);
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ИзменитьФлагВыбранВДеревеВидовЦен(Строки, ФлагВыбран = Истина)
	Для Каждого СтрокаТЧ Из Строки Цикл
		
		Если СтрокаТЧ.ЭтоГруппа Тогда
			ИзменитьФлагВыбранВДеревеВидовЦен(СтрокаТЧ.Строки, ФлагВыбран);
			Продолжить;
		КонецЕсли;
		
		СтрокаТЧ.Выбран = ФлагВыбран;
	КонецЦикла;
КонецПроцедуры

&НаСервере
Процедура НайтиВыбранныеВИерархии(Строки, МассивВыбранныхСтрок)
	
	Для Каждого СтрокаТЧ Из Строки Цикл
		
		Если СтрокаТЧ.ЭтоГруппа Тогда
			НайтиВыбранныеВИерархии(СтрокаТЧ.Строки, МассивВыбранныхСтрок);
			Продолжить;
		КонецЕсли;
		
		Если СтрокаТЧ.Выбран Тогда
			МассивВыбранныхСтрок.Добавить(СтрокаТЧ.Ссылка);
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура НачатьПереходНаЦенообразованиеВерсии2_5()
	
	ПараметрыПерехода = УстановкаЦенСервер.ИнициализироватьСтруктуруСостоянияПерехода();
	
	ПараметрыПерехода.ДатаПереходаНаЦенообразование25 = ДатаПереходаНаЦенообразование25;
		
	// заполнить данные для шага 1 - создание ИПЛ
	ТекстЗапроса = "ВЫБРАТЬ
	|	СоглашенияСКлиентами.Ссылка КАК Ссылка
	|ПОМЕСТИТЬ врТабСоглашенияДляОбработки
	|ИЗ
	|	Справочник.СоглашенияСКлиентами КАК СоглашенияСКлиентами
	|ГДЕ
	|	СоглашенияСКлиентами.Статус <> ЗНАЧЕНИЕ(Перечисление.СтатусыСоглашенийСКлиентами.Закрыто)
	|	И (СоглашенияСКлиентами.ДатаОкончанияДействия >= &ДатаПерехода
	|	ИЛИ СоглашенияСКлиентами.ДатаОкончанияДействия = ДАТАВРЕМЯ(1, 1, 1))
	|	И СоглашенияСКлиентами.ИндивидуальныйВидЦены = ЗНАЧЕНИЕ(Справочник.ВидыЦен.ПустаяСсылка)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	врТабСоглашенияДляОбработки.Ссылка КАК Ссылка
	|ИЗ
	|	врТабСоглашенияДляОбработки КАК врТабСоглашенияДляОбработки
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.СоглашенияСКлиентами.ЦеновыеГруппы КАК СоглашенияСКлиентамиЦеновыеГруппы
	|		ПО врТабСоглашенияДляОбработки.Ссылка = СоглашенияСКлиентамиЦеновыеГруппы.Ссылка
	|
	|ОБЪЕДИНИТЬ
	|
	|ВЫБРАТЬ
	|	врТабСоглашенияДляОбработки.Ссылка
	|ИЗ
	|	врТабСоглашенияДляОбработки КАК врТабСоглашенияДляОбработки
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.СоглашенияСКлиентами.Товары КАК СоглашенияСКлиентамиТовары
	|		ПО врТабСоглашенияДляОбработки.Ссылка = СоглашенияСКлиентамиТовары.Ссылка";

	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;

	Запрос.УстановитьПараметр("ДатаПерехода", ДатаПереходаНаЦенообразование25);

	ТаблицаСоглашений = Запрос.Выполнить().Выгрузить();
	
	ТаблицаДляОбработки = ПараметрыПерехода.ПараметрыШага1.ТаблицаДляОбработки;//ТаблицаЗначений
	
	Для каждого Строка из ТаблицаСоглашений Цикл
		НоваяСтрока = ТаблицаДляОбработки.Добавить();
		НоваяСтрока.Ссылка = Строка.Ссылка; 
		НоваяСтрока.Состояние = Перечисления.СостоянияЗаданий.Запланировано; 
	КонецЦикла;

	ПараметрыПерехода.ПараметрыШага1.Состояние = Перечисления.СостоянияЗаданий.Запланировано; 
	ПараметрыПерехода.ПараметрыШага1.КоличествоВсего = ТаблицаСоглашений.Количество(); 
	
	// заполнить данные для шага 2 - проверка и создание разрезов ценообразования
	ТекстЗапроса = "ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ВЫБОР
	|		КОГДА ВидыНоменклатуры.ВладелецХарактеристик = ЗНАЧЕНИЕ(Справочник.ВидыНоменклатуры.ПустаяСсылка)
	|			ТОГДА ВидыНоменклатуры.Ссылка
	|		ИНАЧЕ ВидыНоменклатуры.ВладелецХарактеристик
	|	КОНЕЦ КАК Ссылка
	|ИЗ
	|	Справочник.ВидыНоменклатуры КАК ВидыНоменклатуры
	|ГДЕ
	|	ВидыНоменклатуры.НастройкиКлючаЦенПоХарактеристике <> ЗНАЧЕНИЕ(Перечисление.ВариантОтбораДляКлючаЦен.НеИспользовать)
	|
	|ОБЪЕДИНИТЬ
	|
	|ВЫБРАТЬ
	|	ВЫБОР
	|		КОГДА ВидыНоменклатуры.ВладелецСерий = ЗНАЧЕНИЕ(Справочник.ВидыНоменклатуры.ПустаяСсылка)
	|			ТОГДА ВидыНоменклатуры.Ссылка
	|		ИНАЧЕ ВидыНоменклатуры.ВладелецСерий
	|	КОНЕЦ
	|ИЗ
	|	Справочник.ВидыНоменклатуры КАК ВидыНоменклатуры
	|ГДЕ
	|	ВидыНоменклатуры.НастройкиКлючаЦенПоСерии <> ЗНАЧЕНИЕ(Перечисление.ВариантОтбораДляКлючаЦен.НеИспользовать)";

	Запрос = Новый Запрос(ТекстЗапроса);

	ТаблицаДляОбработки = ПараметрыПерехода.ПараметрыШага2.ТаблицаДляОбработки;//ТаблицаЗначений
	
	ТаблицаВидовНоменклатуры = Запрос.Выполнить().Выгрузить();
	Для каждого Строка из ТаблицаВидовНоменклатуры Цикл

		НоваяСтрока = ТаблицаДляОбработки.Добавить();
		НоваяСтрока.Ссылка = Строка.Ссылка;
		НоваяСтрока.Состояние = Перечисления.СостоянияЗаданий.Запланировано;
		 
	КонецЦикла;

	ПараметрыПерехода.ПараметрыШага2.Состояние = Перечисления.СостоянияЗаданий.Запланировано; 
	ПараметрыПерехода.ПараметрыШага2.КоличествоВсего = ТаблицаВидовНоменклатуры.Количество(); 
	
	// заполнить данные для шага 3 - переноса цен
	Дерево = РеквизитФормыВЗначение("ДеревоВыбранныеЦены", Тип("ДеревоЗначений"));

	МассивВыбранныхСтрок = Новый Массив;
	Если Дерево.Строки.Количество() > 0 Тогда
		НайтиВыбранныеВИерархии(Дерево.Строки, МассивВыбранныхСтрок);
		
		ТаблицаДляОбработки = ПараметрыПерехода.ПараметрыШага3.ТаблицаДляОбработки;//ТаблицаЗначений
		
		Для Каждого Элемент Из МассивВыбранныхСтрок Цикл
			НоваяСтрока = ТаблицаДляОбработки.Добавить();
			НоваяСтрока.Ссылка = Элемент; 
			НоваяСтрока.Состояние = Перечисления.СостоянияЗаданий.Запланировано; 
		КонецЦикла;
	КонецЕсли;
	
	ПараметрыПерехода.ПараметрыШага3.Состояние = Перечисления.СостоянияЗаданий.Запланировано; 
	ПараметрыПерехода.ПараметрыШага3.КоличествоВсего = МассивВыбранныхСтрок.Количество(); 
	
	УстановкаЦенСервер.НачатьПереходНаЦенообразованиеВерсии2_5(ПараметрыПерехода);
	
КонецПроцедуры

// Состояние перехода.
// 
// Возвращаемое значение:
//  Структура - Состояние перехода:
// * ДатаПереходаНаЦенообразование25 - Дата -
// * ДатаНачала - Дата -
// * ДатаЗавершения - Дата -
// * Шаг - Число -
// * Состояние - ПеречислениеСсылка.СостоянияЗаданий -
// * ПараметрыШага1 - см. ИнициализироватьСтруктуруПараметровПерехода
// * ПараметрыШага2 - см. ИнициализироватьСтруктуруПараметровПерехода
// * ПараметрыШага3 - см. ИнициализироватьСтруктуруПараметровПерехода
&НаСервереБезКонтекста
Функция СостояниеПерехода()
	
	СостояниеПерехода = УстановкаЦенСервер.СостояниеПереходаНаЦенообразованиеВерсии2_5();
		
	Возврат СостояниеПерехода;
	
КонецФункции

&НаКлиенте
Процедура ОбновлениеСтатусаПерехода()
	
	ОбновлениеСтатусаПереходаНаСервере();
	
	Элементы.Шаг1НадписьВыполнено.Видимость 			= (СостояниеШаг1 = ПредопределенноеЗначение("Перечисление.СостоянияЗаданий.Завершено"));
	Элементы.Шаг1НадписьВыполняется.Видимость 			= (СостояниеШаг1 = ПредопределенноеЗначение("Перечисление.СостоянияЗаданий.Выполняется"));
	Элементы.Шаг1НадписьНеВыполняется.Видимость 		= (СостояниеШаг1 = ПредопределенноеЗначение("Перечисление.СостоянияЗаданий.Запланировано"));
	Элементы.Шаг1НадписьВыполненоСОшибками.Видимость 	= (СостояниеШаг1 = ПредопределенноеЗначение("Перечисление.СостоянияЗаданий.ОшибкаВыполнения"));
	
	Элементы.Шаг2НадписьВыполнено.Видимость 			= (СостояниеШаг2 = ПредопределенноеЗначение("Перечисление.СостоянияЗаданий.Завершено"));
	Элементы.Шаг2НадписьВыполняется.Видимость 			= (СостояниеШаг2 = ПредопределенноеЗначение("Перечисление.СостоянияЗаданий.Выполняется"));
	Элементы.Шаг2НадписьНеВыполняется.Видимость 		= (СостояниеШаг2 = ПредопределенноеЗначение("Перечисление.СостоянияЗаданий.Запланировано"));
	Элементы.Шаг2НадписьВыполненоСОшибками.Видимость 	= (СостояниеШаг2 = ПредопределенноеЗначение("Перечисление.СостоянияЗаданий.ОшибкаВыполнения"));
	
	Элементы.Шаг3НадписьВыполнено.Видимость 			= (СостояниеШаг3 = ПредопределенноеЗначение("Перечисление.СостоянияЗаданий.Завершено"));
	Элементы.Шаг3НадписьВыполняется.Видимость 			= (СостояниеШаг3 = ПредопределенноеЗначение("Перечисление.СостоянияЗаданий.Выполняется"));
	Элементы.Шаг3НадписьНеВыполняется.Видимость 		= (СостояниеШаг3 = ПредопределенноеЗначение("Перечисление.СостоянияЗаданий.Запланировано"));
	Элементы.Шаг3НадписьВыполненоСОшибками.Видимость 	= (СостояниеШаг3 = ПредопределенноеЗначение("Перечисление.СостоянияЗаданий.ОшибкаВыполнения"));
	
	Если ЗначениеЗаполнено(ДатаЗавершения) Тогда
		
		ОтключитьОбработчикОжидания("ОбновлениеСтатусаПерехода");
		Если ЗначениеЗаполнено(Задание) Тогда
			Если ВыключитьМонопольныйРежим() Тогда
				Задание = Неопределено;
				ОтключитьОбработчикОжидания("ОбновлениеСтатусаПерехода");
			КонецЕсли;
		КонецЕсли;
		
		Если Состояние = ПредопределенноеЗначение("Перечисление.СостоянияЗаданий.ОшибкаВыполнения") Тогда
			НоваяСтраница = Элементы.СтраницаОшибка;
		Иначе
			НоваяСтраница = Элементы.СтраницаРезультат;
		КонецЕсли;
		
		Оповестить("Запись_НаборКонстант", Новый Структура, "ИспользуетсяЦенообразование25");
		
		ОткрытиеСтраницы(НоваяСтраница);
		
		Если Не Открыта() Тогда
			Открыть();
		КонецЕсли;
		
	Иначе
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОбновлениеСтатусаПереходаНаСервере()
	
	СостояниеПерехода = СостояниеПерехода();
	
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, СостояниеПерехода);
	
	СостояниеШаг1 = СостояниеПерехода.ПараметрыШага1.Состояние;
	СостояниеШаг2 = СостояниеПерехода.ПараметрыШага2.Состояние;
	СостояниеШаг3 = СостояниеПерехода.ПараметрыШага3.Состояние;

КонецПроцедуры

&НаСервере
Функция ЕстьОшибкиПриПереносеЦен()
	
	СостояниеПерехода = СостояниеПерехода();
	
	Возврат (СостояниеПерехода.ПараметрыШага3.КоличествоОшибок > 0);

КонецФункции

&НаСервере
Функция ПолучитьВидыЦенСОшибками()
	
	СостояниеПерехода = СостояниеПерехода();
	
	МассивВидовЦен = Новый Массив();
	Для Каждого Строка Из СостояниеПерехода.ПараметрыШага3.ТаблицаДляОбработки Цикл//СтрокаТаблицыЗначений
		Если Строка.Состояние = Перечисления.СостоянияЗаданий.ОшибкаВыполнения Тогда
			МассивВидовЦен.Добавить(Строка.Ссылка);
		КонецЕсли;
	КонецЦикла;
	
	Возврат МассивВидовЦен;

КонецФункции

&НаСервере
Процедура ОчиститьСостояниеПерехода()
	
	РегистрыСведений.СостояниеПереходаНаЦенообразованиеВерсии25.СоздатьНаборЗаписей().Записать();
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытиемОповещение(Результат, Параметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		Оповестить("Запись_НаборКонстант", Новый Структура, "ИспользуетсяЦенообразование25");
		ЗакрытьБезусловно = Истина;
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ВыключитьМонопольныйРежим()
	
	Попытка
		УстановитьМонопольныйРежим(Ложь);
	Исключение
		Возврат Ложь;
	КонецПопытки;

	Возврат Истина;
	
КонецФункции

&НаКлиенте
Процедура ПриОткрытииФормы(ПриНачалеРаботыСистемы = Ложь) Экспорт
	
	Если Состояние = ПредопределенноеЗначение("Перечисление.СостоянияЗаданий.Завершено") Тогда
		НоваяСтраница = Элементы.СтраницаРезультат;
	ИначеЕсли Состояние = ПредопределенноеЗначение("Перечисление.СостоянияЗаданий.ОшибкаВыполнения") Тогда
		НоваяСтраница = Элементы.СтраницаОшибка;
	ИначеЕсли Состояние = ПредопределенноеЗначение("Перечисление.СостоянияЗаданий.Выполняется") 
		Или Состояние = ПредопределенноеЗначение("Перечисление.СостоянияЗаданий.Запланировано") Тогда
		НоваяСтраница = Элементы.СтраницаОжидание;
	Иначе
		Если ЦенообразованиеВызовСервера.ИспользуетсяЦенообразование25() Тогда
			НоваяСтраница = Элементы.СтраницаВозвратаНаСтароеЦенообразование;
		Иначе
			НоваяСтраница = Элементы.СтраницаНачальная;
		КонецЕсли;	
	КонецЕсли;
	
	ОткрытиеСтраницы(НоваяСтраница);
	
	Если ПриНачалеРаботыСистемы 
		И (ЗначениеЗаполнено(ДатаЗавершения)) 
		И Не Открыта() Тогда
		Открыть();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура НастроитьФорму()
	
	Элементы.ДекорацияИнформацияПроверкаВидовНоменклатуры1.Видимость = ИспользоватьХарактеристикиНоменклатуры;
	
	Элементы.ДекорацияИнформацияПроверкаВидовНоменклатуры2.Видимость = ИспользоватьСерииНоменклатуры;
	
	Элементы.ДекорацияИнформацияПроверкаВидовНоменклатуры3.Видимость = ИспользоватьУпаковкиНоменклатуры;
	
	//++ НЕ УТ
	ПереименоватьВерсиюЦенообразования();
	//-- НЕ УТ
	
КонецПроцедуры

//++ НЕ УТ
&НаСервере
Процедура ПереименоватьВерсиюЦенообразования()
	
	СкорректироватьВерсиюЦенообразования(Элементы.ДекорацияИнформацияНачальнаяСтраница.Заголовок);
	СкорректироватьВерсиюЦенообразования(Элементы.ДекорацияИнформацияНачальнаяСтраница1.Подсказка);
	СкорректироватьВерсиюЦенообразования(Элементы.ДатаПереходаНаЦенообразование25.Заголовок);
	СкорректироватьВерсиюЦенообразования(Элементы.ДатаПереходаНаЦенообразование1.Заголовок);
	СкорректироватьВерсиюЦенообразования(Элементы.ДекорацияИнформацияЗапускаАвтоматическогоПереходаЗаголовок.Заголовок);
	СкорректироватьВерсиюЦенообразования(Элементы.ДекорацияИнформация3.Заголовок);
	СкорректироватьВерсиюЦенообразования(Элементы.ДекорацияРезультат20.Заголовок);
	СкорректироватьВерсиюЦенообразования(Элементы.ДекорацияРезультат25.Заголовок);
	СкорректироватьВерсиюЦенообразования(Элементы.ДекорацияИнформацияВозвратанаСтароеЦенообразованиеЗаголовок.Заголовок);
	СкорректироватьВерсиюЦенообразования(Элементы.ДекорацияИнформацияЗапускаАвтоматическогоВозврата1.Заголовок);
	СкорректироватьВерсиюЦенообразования(Элементы.СтраницаВозвратаНаСтароеЦенообразование.Подсказка);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура СкорректироватьВерсиюЦенообразования(СтрокаДляИзменения)
	СтрокаДляИзменения = СтрЗаменить(СтрокаДляИзменения, "11.", "2.");
КонецПроцедуры
//-- НЕ УТ

&НаСервере
Процедура УстановитьУсловноеОформление()

	УсловноеОформление.Элементы.Очистить();

	//

	Элемент = УсловноеОформление.Элементы.Добавить();
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ДеревоВыбранныеЦеныВыбран.Имя);
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ДеревоВыбранныеЦены.ЭтоГруппа");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;	
	Элемент.Оформление.УстановитьЗначениеПараметра("ТолькоПросмотр",Истина); 

КонецПроцедуры

&НаКлиенте
Процедура ДекорацияИнформация4ОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ВидыЦен", ПолучитьВидыЦенСОшибками());
	
	ОткрытьФорму("Обработка.ПрайсЛист.Форма.Форма",ПараметрыФормы,, ЭтаФорма.УникальныйИдентификатор,,,,);

КонецПроцедуры 

#КонецОбласти

#КонецОбласти
