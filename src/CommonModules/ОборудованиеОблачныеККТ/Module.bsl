
#Область СлужебныйПрограммныйИнтерфейс

// Добавляет в список поставляемые драйверы в составе конфигурации.
//
// Параметры:
//  ДрайвераОборудования - см. МенеджерОборудования.НоваяТаблицаПоставляемыхДрайверовОборудования
//
Процедура ОбновитьПоставляемыеДрайвера(ДрайвераОборудования) Экспорт
	
	// ++ Локализация
	Драйвер = ДрайвераОборудования.Добавить();
	Драйвер.ТипОборудования = Перечисления.ТипыПодключаемогоОборудования.ОблачнаяККТ;
	Драйвер.ИмяДрайвера  = "ОбработчикОблачныхККТ";
	Драйвер.Наименование = НСтр("ru = 'Обработчик работы с облачными ККТ';
								|en = 'Cloud cash register operation handler'", ОбщегоНазначенияБПО.КодОсновногоЯзыка());
	Драйвер.ИдентификаторОбъекта = "CloudKKT"; 
	// -- Локализация
	
КонецПроцедуры

#КонецОбласти
